//
//  ClientInformationInteractor.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 08/11/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ClientInformationBusinessLogic {
    func doGetAppointmentHistory(request: ClientInformation.GetAppointnentHistory.Request, method: HTTPMethod)
    func doGetMembershipDetails(accessToken: String, method: HTTPMethod, request: ClientInformation.MembershipDetails.Request)
    func doGetClientPreferences(accessToken: String, method: HTTPMethod, request: ClientInformation.Preferences.Request)
    func doGetClientNotes(method: HTTPMethod, request: ClientInformation.ClientNotes.Request)
    func doGetGenericFormData(request: GenericCustomerConsulation.FormData.Request, method: HTTPMethod)
    func doPostGenericFormData(request: GenericCustomerConsulation.SubmitFormData.Request, method: HTTPMethod)
}

class ClientInformationInteractor: ClientInformationBusinessLogic {
    var presenter: ClientInformationPresentationLogic?
    var worker: ClientInformationWorker?
    //var name: String = ""

    // MARK: Do something

    func doGetAppointmentHistory(request: ClientInformation.GetAppointnentHistory.Request, method: HTTPMethod) {
        worker = ClientInformationWorker()
        worker?.presenter = self.presenter
        worker?.postRequestForAppointmentHistory(request: request, method: method)
    }

    func doGetMembershipDetails(accessToken: String, method: HTTPMethod, request: ClientInformation.MembershipDetails.Request) {
        worker = ClientInformationWorker()
        worker?.presenter = self.presenter
        worker?.getRequestForMembershipDetails(accessToken: accessToken, method: method, request: request)
    }

    func doGetClientPreferences(accessToken: String, method: HTTPMethod, request: ClientInformation.Preferences.Request) {
        worker = ClientInformationWorker()
        worker?.presenter = self.presenter
        worker?.getRequestForClientPreference(accessToken: accessToken, method: method, request: request)
    }

    func doGetClientNotes(method: HTTPMethod, request: ClientInformation.ClientNotes.Request) {
        worker = ClientInformationWorker()
        worker?.presenter = self.presenter
        worker?.postRequestForClientNotes(request: request, method: method)
    }
    
    func doGetGenericFormData(request: GenericCustomerConsulation.FormData.Request, method: HTTPMethod) {
        worker = ClientInformationWorker()
        worker?.presenter = self.presenter
        worker?.getGenericConsultationForm(request: request, method: method)
    }


    func doPostGenericFormData(request: GenericCustomerConsulation.SubmitFormData.Request, method: HTTPMethod) {
        worker = ClientInformationWorker()
        worker?.presenter = self.presenter
        worker?.postSubmitGenericForm(request: request, method: method)
    }

}
