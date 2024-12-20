import Foundation

class ChChChanges {
  private typealias CallbackDict = [[String.SubSequence]: ([URL]) -> Void]
  private nonisolated(unsafe) static var callbacks: CallbackDict = [:]

	@discardableResult init(_ url: URL, callback: @escaping ([URL]) -> Void) {
		ChChChanges.callbacks[url.absoluteString.split(separator: "/")] = callback

		let handler: FSEventStreamCallback = { (_, _, numEvents, eventPaths, _, _) in
		  let bufferPathsStart = eventPaths.assumingMemoryBound(to: UnsafePointer<CChar>.self)
			let bufferPaths = UnsafeBufferPointer(start: bufferPathsStart, count: numEvents)
			let eventURLs = (0..<numEvents).map { URL(bufferPath: bufferPaths[$0]) }

			if let firstURL = Array(Set(eventURLs)).first {
				var components = firstURL.absoluteString.split(separator: "/")

				while components.count > 0 {
					if let callback = ChChChanges.callbacks[components] {
						callback(eventURLs)
						break
					}

					components = components.dropLast()
				}
			}
		}

		let allocator: CFAllocator? = nil
		let context: UnsafeMutablePointer<FSEventStreamContext>? = nil
		let pathsToWatch = [url.path() as NSString] as NSArray
		let sinceWhen = UInt64(kFSEventStreamEventIdSinceNow)
		let latency = 1.0
		let flags = FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents)

		let stream = FSEventStreamCreate(allocator, handler, context, pathsToWatch, sinceWhen, latency, flags)!
		FSEventStreamSetDispatchQueue(stream, DispatchQueue.main)
		FSEventStreamStart(stream)
	}
}

extension URL {
  init(bufferPath: UnsafePointer<Int8>) {
		self = URL(fileURLWithFileSystemRepresentation: bufferPath, isDirectory: false, relativeTo: nil)
	}

  public func watchForChChChanges(callback: @escaping ([URL]) -> Void) {
    ChChChanges(self, callback: callback)
  }
}
