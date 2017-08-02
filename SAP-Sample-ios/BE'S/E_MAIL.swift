import UIKit

// This class is part of the BE "PERSON".
@objc(E_MAIL)
class E_MAIL: DataStructure {

	// Table Name
	static let TABLE_NAME = "E_MAIL"
	
		// Client
	static let MANDT = "MANDT"

	// Person Number (Sample Application)
	static let PERSNUMBER = "PERSNUMBER"

	// Seqeunce Number (Sample Application)
	static let SEQNO_E_MAIL = "SEQNO_E_MAIL"

	// E-mail Address (Sample Application)
	static let E_ADDR = "E_ADDR"

	// E-mail Address Description (Sample Application)
	static let E_ADDR_TEXT = "E_ADDR_TEXT"


	
	// The Initializer
	override init() {
		super.init(E_MAIL.TABLE_NAME, isHeader: false)
	}

		var MANDT: String? {
		get {
			return getField(E_MAIL.MANDT) as? String
		}
		set (value) {
			setField(E_MAIL.MANDT, value: value)
		}
	}

	var PERSNUMBER: NSNumber? {
		get {
			return getField(E_MAIL.PERSNUMBER) as? NSNumber
		}
		set (value) {
			setField(E_MAIL.PERSNUMBER, value: value)
		}
	}

	var SEQNO_E_MAIL: NSNumber? {
		get {
			return getField(E_MAIL.SEQNO_E_MAIL) as? NSNumber
		}
		set (value) {
			setField(E_MAIL.SEQNO_E_MAIL, value: value)
		}
	}

	var E_ADDR: String? {
		get {
			return getField(E_MAIL.E_ADDR) as? String
		}
		set (value) {
			setField(E_MAIL.E_ADDR, value: value)
		}
	}

	var E_ADDR_TEXT: String? {
		get {
			return getField(E_MAIL.E_ADDR_TEXT) as? String
		}
		set (value) {
			setField(E_MAIL.E_ADDR_TEXT, value: value)
		}
	}


}