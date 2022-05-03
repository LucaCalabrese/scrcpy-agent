//
//  ViewController.swift
//  scrcpy-agent
//
//  Created by luca.calabrese on 04/04/22.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    static func newInstance() -> ViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("ViewController")
          
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Unable to instantiate ViewController in Main.storyboard")
        }
        return viewcontroller
    }

    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!

    
    @IBAction func startMirror(_ sender: Any) {
        startButton.isHidden = true
        stopButton.isHidden = false
        
        DispatchQueue.global().async {
            self.shell("export PATH=/opt/homebrew/bin/:$PATH; /opt/homebrew/bin/scrcpy")
            DispatchQueue.main.async {
                self.startButton.isHidden = false
                self.stopButton.isHidden = true
            }
        }
    }
    @IBAction func stopMirror(_ sender: Any) {
        if(!self.shell("killall -15 scrcpy").isEmpty){
            self.startButton.isHidden = false
            self.stopButton.isHidden = true
        }
    }
    
}

