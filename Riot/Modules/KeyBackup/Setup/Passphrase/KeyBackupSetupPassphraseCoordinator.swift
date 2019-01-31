/*
 Copyright 2019 New Vector Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import UIKit

final class KeyBackupSetupPassphraseCoordinator: KeyBackupSetupPassphraseCoordinatorType {
    
    // MARK: - Properties
    
    // MARK: Private
    
    private let session: MXSession
    private var keyBackupSetupPassphraseViewModel: KeyBackupSetupPassphraseViewModelType
    private let keyBackupSetupPassphraseViewController: KeyBackupSetupPassphraseViewController
    
    // MARK: Public
    
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: KeyBackupSetupPassphraseCoordinatorDelegate?
    
    // MARK: - Setup
    
    init(session: MXSession) {
        self.session = session
        
        let keyBackup = MXKeyBackup(matrixSession: session)
        let keyBackupSetupPassphraseViewModel = KeyBackupSetupPassphraseViewModel(keyBackup: keyBackup)
        let keyBackupSetupPassphraseViewController = KeyBackupSetupPassphraseViewController.instantiate(with: keyBackupSetupPassphraseViewModel)
        self.keyBackupSetupPassphraseViewModel = keyBackupSetupPassphraseViewModel
        self.keyBackupSetupPassphraseViewController = keyBackupSetupPassphraseViewController
    }
    
    // MARK: - Public methods
    
    func start() {            
        self.keyBackupSetupPassphraseViewModel.coordinatorDelegate = self
    }
    
    func toPresentable() -> UIViewController {
        return self.keyBackupSetupPassphraseViewController
    }
}

// MARK: - KeyBackupSetupPassphraseViewModelCoordinatorDelegate
extension KeyBackupSetupPassphraseCoordinator: KeyBackupSetupPassphraseViewModelCoordinatorDelegate {
    func keyBackupSetupPassphraseViewModelDidCancel(_ viewModel: KeyBackupSetupPassphraseViewModelType) {
        self.delegate?.keyBackupSetupPassphraseCoordinatorDidCancel(self)
    }
    
    func keyBackupSetupPassphraseViewModel(_ viewModel: KeyBackupSetupPassphraseViewModelType, didCompleteWithMegolmBackupCreationInfo megolmBackupCreationInfo: MXMegolmBackupCreationInfo) {
        self.delegate?.keyBackupSetupPassphraseCoordinator(self, didCompleteWithMegolmBackupCreationInfo: megolmBackupCreationInfo)
    }
}