//
//  AppDelegate.swift
//  PostureDetect
//
//  Created by Maryam on 07/03/2025.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    
    static var shared: AppDelegate?
    private var cameraManager: CameraManager?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.shared = self
        cameraManager = CameraManager()
        // إنشاء أيقونة في شريط القائمة
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "figure.wave", accessibilityDescription: "Posture Detect")
            button.action = #selector(togglePopover)
        } else {
            print("Failed to create status item button.") // إذا ظهرت هذه الرسالة، فهناك مشكلة في إنشاء statusItem
        }
        
        // إنشاء Popover لعرض الإشعارات
        let contentView = ContentView() // يمكنك استبدالها بواجهة الإشعارات الخاصة بك
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 300, height: 200)
        popover?.behavior = .semitransient
        popover?.contentViewController = NSHostingController(rootView: contentView)
        
        if popover == nil {
            print("Failed to create popover.") // إذا ظهرت هذه الرسالة، فهناك مشكلة في إنشاء popover
        }
    }
    
    // دالة لعرض Popover تلقائيًا
    func showPopover() {
        print("Attempting to show popover automatically...") // هذه الرسالة يجب أن تظهر
        guard let button = statusItem?.button, let popover = popover else {
            print("Button or popover is nil.") // إذا ظهرت هذه الرسالة، فهناك مشكلة في التهيئة
            return
        }
        
        if !popover.isShown {
            print("Showing popover automatically...") // إذا ظهرت هذه الرسالة، فـ Popover يتم عرضه
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.hidePopover()
                    }
        } else {
            print("Popover is already shown.") // إذا ظهرت هذه الرسالة، فـ Popover مفتوح بالفعل
        }
    }
    
    // دالة لإغلاق Popover
    func hidePopover() {
        guard let popover = popover else {
            print("Popover is nil.")
            return
        }
        
        if popover.isShown {
            print("Hiding popover...")
            popover.performClose(nil)
        }
    }
    
    // دالة للتبديل بين عرض وإخفاء Popover (عند النقر على الأيقونة)
    @objc func togglePopover() {
        guard let button = statusItem?.button, let popover = popover else {
            print("Button or popover is nil.")
            return
        }
        
        if popover.isShown {
            hidePopover()
        } else {
            showPopover()
        }
    }
}
