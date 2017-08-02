import UIKit

// This class is part of the BE "PERSON".
@objc(PERSON_HEADER)
class PERSON_HEADER: DataStructure {

	// Table Name
	static let TABLE_NAME = "PERSON_HEADER"
	
		// Client
	static let MANDT = "MANDT"

	// Person Number (Sample Application)
	static let PERSNUMBER = "PERSNUMBER"

	// First Name (Sample Application)
	static let FIRST_NAME = "FIRST_NAME"

	// Last Name (Sample Application)
	static let LAST_NAME = "LAST_NAME"

	// Profession (Sample Application)
	static let PROFESSION = "PROFESSION"

	// Gender (Sample Application)
	static let SEX = "SEX"

	// Birthday (Sample Application)
	static let BIRTHDAY = "BIRTHDAY"

	// Weight (Sample Application)
	static let WEIGHT = "WEIGHT"

	// Height (Sample Application)
	static let HEIGHT = "HEIGHT"

	// Category1 (Sample Application)
	static let CATEGORY1 = "CATEGORY1"

	// Category2 (Sample Application)
	static let CATEGORY2 = "CATEGORY2"

	// Created on
	static let CREDAT = "CREDAT"

	// Created by
	static let CRENAM = "CRENAM"

	// Create Time
	static let CRETIM = "CRETIM"

	// Last Changed on
	static let CHGDAT = "CHGDAT"

	// Last Changed by
	static let CHGNAM = "CHGNAM"

	// Last Changed at
	static let CHGTIM = "CHGTIM"


	
	// The Initializer
	override init() {
		super.init(PERSON_HEADER.TABLE_NAME, isHeader: true)
	}

		var MANDT: String? {
		get {
			return getField(PERSON_HEADER.MANDT) as? String
		}
		set (value) {
			setField(PERSON_HEADER.MANDT, value: value)
		}
	}

	var PERSNUMBER: NSNumber? {
		get {
			return getField(PERSON_HEADER.PERSNUMBER) as? NSNumber
		}
		set (value) {
			setField(PERSON_HEADER.PERSNUMBER, value: value)
		}
	}

	var FIRST_NAME: String? {
		get {
			return getField(PERSON_HEADER.FIRST_NAME) as? String
		}
		set (value) {
			setField(PERSON_HEADER.FIRST_NAME, value: value)
		}
	}

	var LAST_NAME: String? {
		get {
			return getField(PERSON_HEADER.LAST_NAME) as? String
		}
		set (value) {
			setField(PERSON_HEADER.LAST_NAME, value: value)
		}
	}

	var PROFESSION: String? {
		get {
			return getField(PERSON_HEADER.PROFESSION) as? String
		}
		set (value) {
			setField(PERSON_HEADER.PROFESSION, value: value)
		}
	}

	var SEX: String? {
		get {
			return getField(PERSON_HEADER.SEX) as? String
		}
		set (value) {
			setField(PERSON_HEADER.SEX, value: value)
		}
	}

	var BIRTHDAY: String? {
		get {
			return getField(PERSON_HEADER.BIRTHDAY) as? String
		}
		set (value) {
			setField(PERSON_HEADER.BIRTHDAY, value: value)
		}
	}

	var WEIGHT: NSNumber? {
		get {
			return getField(PERSON_HEADER.WEIGHT) as? NSNumber
		}
		set (value) {
			setField(PERSON_HEADER.WEIGHT, value: value)
		}
	}

	var HEIGHT: NSNumber? {
		get {
			return getField(PERSON_HEADER.HEIGHT) as? NSNumber
		}
		set (value) {
			setField(PERSON_HEADER.HEIGHT, value: value)
		}
	}

	var CATEGORY1: NSNumber? {
		get {
			return getField(PERSON_HEADER.CATEGORY1) as? NSNumber
		}
		set (value) {
			setField(PERSON_HEADER.CATEGORY1, value: value)
		}
	}

	var CATEGORY2: String? {
		get {
			return getField(PERSON_HEADER.CATEGORY2) as? String
		}
		set (value) {
			setField(PERSON_HEADER.CATEGORY2, value: value)
		}
	}

	var CREDAT: String? {
		get {
			return getField(PERSON_HEADER.CREDAT) as? String
		}
		set (value) {
			setField(PERSON_HEADER.CREDAT, value: value)
		}
	}

	var CRENAM: String? {
		get {
			return getField(PERSON_HEADER.CRENAM) as? String
		}
		set (value) {
			setField(PERSON_HEADER.CRENAM, value: value)
		}
	}

	var CRETIM: String? {
		get {
			return getField(PERSON_HEADER.CRETIM) as? String
		}
		set (value) {
			setField(PERSON_HEADER.CRETIM, value: value)
		}
	}

	var CHGDAT: String? {
		get {
			return getField(PERSON_HEADER.CHGDAT) as? String
		}
		set (value) {
			setField(PERSON_HEADER.CHGDAT, value: value)
		}
	}

	var CHGNAM: String? {
		get {
			return getField(PERSON_HEADER.CHGNAM) as? String
		}
		set (value) {
			setField(PERSON_HEADER.CHGNAM, value: value)
		}
	}

	var CHGTIM: String? {
		get {
			return getField(PERSON_HEADER.CHGTIM) as? String
		}
		set (value) {
			setField(PERSON_HEADER.CHGTIM, value: value)
		}
	}


}