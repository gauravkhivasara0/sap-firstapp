// namespace firstapp;

// using { firstapp.common as common } from './common';
// using { managed, temporal } from '@sap/cds/common';

// // Syntax for an identifier
// // type ![EmployeeName] : String(50);
// type str20 : String(20);

// entity Students : common.Address, common.feeasp, managed, temporal {
// 	key stuId: Integer;
// 	stuName: common.str50;
// 	gender: common.gender;
// 	fatherName: common.str50;
// 	motherName: common.str50;
// 	contactNo: common.PhoneNumber;
// 	email: common.Email;

// 	abc: Association to one Classes;
// 	// Unmanaged association
// 	book: Association to many Books on book.stuId = $self;
// }

// entity Classes : managed, temporal {
// 	key classId: Integer;
// 	className: common.str50;
// 	teacherName: common.str50;
// }

// entity Employees {
// 	key empId: Integer;
// 	empName: common.str50;
// 	salary: str20;
// 	dept: str20;
// 	currencyCode: String(30);
// 	city: str20;
// 	country: str20;
// 	division: Association to one Divisions;
// }

// entity Divisions {
// 	key divId: Integer;
// 	divName: str20;
// 	city: str20;
// 	country: str20;
// }

// entity Books {
// 	key bookId: Integer;
// 	bookName: common.str50;
// 	author: common.str50;
// 	price: Decimal;
// 	stock: Integer;
// 	status: common.status;
// 	dateOfIssue: DateTime;
// 	dateOfReturn: DateTime;

// 	stuId: Association to one Students;
// }

// entity Marks {
// 	subj: str20;
// 	marks: Integer;
// 	totMarks: Integer;
// 	percentage: Decimal;

// 	stuId: Association to one Students;
// }



// entity Albums {
// 	key id: Integer;
// 	title: String(120) not null;
// 	description: String(255) not null;
// 	view: Integer not null;
// }

// entity Tags {
// 	key id: Integer;
// 	title: String(120) not null;
// }

// entity TagPhotos {
// 	key id: Integer;

// 	tag_id: Association to one Tags;
// 	photo_id: Association to one Photos;
// }

// entity Locations {
// 	key id: Integer;
// 	name: String(200) not null;
// 	short_name: String(50) not null;
// }

// entity Photos {
// 	key id: Integer;
// 	title: String(120) not null;
// 	description: String(255) not null;
// 	privacy: String(20) not null;
// 	upload_date: Date not null;
// 	view: Integer not null;
// 	img_path: String(50) not null;

// 	album_id: Association to one Albums;
// 	location_id: Association to one Locations;
// 	member_id: Association to one Members;
// }

// entity Comments {
// 	key id: Integer;
// 	post_date: Date not null;
// 	content: String(255) not null;
	
// 	photo_id: Association to one Photos;
// }

// entity Members {
// 	key id: Integer;
// 	name: String(255) not null;
// 	phone_number: String(20) not null;
// 	email: String(200) not null;
// 	address: String(255) not null;
// }

namespace firstapp;

using { cuid, Currency } from '@sap/cds/common';
using {firstapp.common as common} from './common';

context master {
    entity BusinessPartners {
        key NODE_KEY: common.Guid;
            BP_ROLE: common.Role;
            EMAIL: common.Email;
            MOBILE: common.PhoneNumber;
            FAX: common.String32;
            WEB: common.String255;
            BP_ID: common.Guid;
            COMPANY_NAME: common.String255;
            // Managed Association
            AD: Association to Addresses;
    }

    entity Addresses : common.Address {
        key NODE_KEY : common.Guid;
            ADDRESS_TYPE : common.String32;
            VAL_START : Date;
            VAL_END : Date;
            LATITUDE : Decimal(9, 6);
            LONGITUDE : Decimal(9, 6);
            // Back-link Association
            BP : Association to one BusinessPartners on BP.AD = $self;
    }

    entity Products {
        key NODE_KEY : common.Guid;
            PRODUCT_ID : common.String32;
            TYPE_CODE : String(2);
            CATEGORY : common.String32;
            DESCRIPTION : common.String255;
            TAX_TARIF_CODE : Integer;
            MEASURE_UNIT : String(2);
            WEIGHT_MEASURE : Decimal(5, 2);
            WEIGHT_UNIT : String(2);
            PRICE : Decimal(15, 2);
            CURRENCY_CODE : String(5);
            WIDTH : Decimal(5, 2);
            DEPTH : Decimal(5, 2);
            HEIGHT : Decimal(5, 2);
            DIM_UNIT : String(2);
            // Supplier Business Partner
            SUPPLIERS : Association to BusinessPartners;
    }

    entity Employees : cuid {
        nameFirst : common.String64;
        nameLast : common.String64;
        nameInitials : common.String64;
        nameMiddle : common.String64;
        gender : common.Gender;
        language : String(2);
        loginName : String(16);
        phoneNumber : common.PhoneNumber;
        email : common.Email;
        Currency : Currency;
        salaryAmount : common.AmountT;
        accountNumber : common.String32;
        bankId : String(16);
        bankName : common.String64;
    }
}

context transaction {
    entity PurchaseOrders : common.Amount {
        key NODE_KEY : common.Guid;
            PO_ID : common.Guid;
            // Managed Association
            PARTNER : Association to master.BusinessPartners;
            LIFECYCLE_STATUS : String(1);
            OVERALL_STATUS : String(1);
            // Unmanaged Association
            Items : Association to many PurchaseItems on Items.PARENT = $self;
    }

    entity PurchaseItems : common.Amount {
        key NODE_KEY : common.Guid;
            // Parent Purchase Order
            PARENT : Association to PurchaseOrders;
            PO_ITEM_POS : Integer;
            // Product Reference
            PRODUCT : Association to master.Products;
    }
}
