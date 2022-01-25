//
//  ImageCache.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/06.
//

import Foundation

final class ImageCache {
    private var memoryCache = NSCache<NSString, NSData>()
    
    var diskCacheFolder: URL {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return cacheURL.appendingPathComponent("SplashCache")
    }
    
    init() {
        self.memoryCache.countLimit = 120
        self.createCacheFolder()
    }
    
    func save(_ data: Data, key: String) {
        self.memoryCache.setObject(NSData(data: data), forKey: NSString(string: key))
        try? data.write(to: self.diskCacheFolder.appendingPathComponent(key))
    }
    
    func load(key: String) -> Data? {
        if let data = memoryCache.object(forKey: NSString(string: key)) {
            return Data(referencing: data)
        }
        
        let cachURL = diskCacheFolder.appendingPathComponent(key)
        if let data = FileManager.default.contents(atPath: cachURL.path) {
            self.memoryCache.setObject(NSData(data: data), forKey: NSString(string: key))
            return data
        }
        
        return nil
    }
    
    func removeAll() {
        try? FileManager.default.removeItem(at: self.diskCacheFolder)
        self.createCacheFolder()
        self.removeMemoryCache()
    }
    
    func removeMemoryCache() {
        self.memoryCache.removeAllObjects()
    }
    
    private func createCacheFolder() {
        guard !FileManager.default.fileExists(atPath: self.diskCacheFolder.path) else { return }
        try? FileManager.default.createDirectory(at: self.diskCacheFolder, withIntermediateDirectories: true, attributes: nil)
    }
}
