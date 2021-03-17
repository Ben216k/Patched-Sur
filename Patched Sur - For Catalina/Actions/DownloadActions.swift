//
//  DownloadActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/16/21.
//

import Foundation
import Files

func kextDownload(size: (Int) -> (), next: () -> (), errorX: (String) -> ()) {
    do {
        print("Clean up before patches download")
        _ = try Folder.home.createSubfolderIfNeeded(at: ".patched-sur")
        _ = try? Folder(path: "~/.patched-sur/big-sur-micropatcher").delete()
        _ = try? call("rm -rf ~/.patched-sur/big-sur-micropatcher*")
        _ = try? File(path: "~/.patched-sur/big-sur-micropatcher.zip").delete()
        print("Getting projected size")
        if let sizeString = try? shellOut(to: "curl -sI https://codeload.github.com/BenSova/big-sur-micropatcher/zip/main | grep -i Content-Length | awk '{print $2}'"), let sizeInt = Int(sizeString) {
            size(sizeInt)
        }
        print("Starting download of patches")
        try call("curl -o ~/.patched-sur/big-sur-micropatcher.zip https://codeload.github.com/BenSova/big-sur-micropatcher/zip/main")
        print("Extracting patches")
        try call("unzip big-sur-micropatcher.zip", at: "~/.patched-sur")
        print("Cleaning up after patches download")
        _ = try? File(path: "~/.patched-sur/big-sur-micropatcher*").delete()
        try call("mv ~/.patched-sur/big-sur-micropatcher-main ~/.patched-sur/big-sur-micropatcher")
        next()
    } catch {
        errorX(error.localizedDescription)
    }
}
