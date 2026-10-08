// namespace firstapp;

// using { firstapp.common as common } from './common';
// using { managed, temporal } from '@sap/cds/common';

// // Syntax for an identifier
// // type ![EmployeeName] : String(50);
// type str20 : String(20);

// entity Students : common.Address, common.feeasp, managed, temporal {
// 	key stuId : Integer;
// 	stuName : common.str50;
// 	gender : common.gender;
// 	fatherName : common.str50;
// 	motherName : common.str50;
// 	contactNo : common.PhoneNumber;
// 	email : common.Email;

// 	abc : Association to one Classes;
// 	// Unmanaged association
// 	book : Association to many Books on book.stuId = $self;
// }

// entity Classes : managed, temporal {
// 	key classId : Integer;
// 	className : common.str50;
// 	teacherName : common.str50;
// }

// entity Employees  {
// 	key empId : Integer;
// 	empName : common.str50;
// 	salary : str20;
// 	dept : str20;
// 	currencyCode : String(30);
// 	city : str20;
// 	country : str20;
// 	division : Association to one Divisions;
// }

// entity Divisions  {
// 	key divId : Integer;
// 	divName : str20;
// 	city : str20;
// 	country : str20;
// }

// entity Books  {
// 	key bookId : Integer;
// 	bookName : common.str50;
// 	author : common.str50;
// 	price : Decimal;
// 	stock : Integer;
// 	status : common.status;
// 	dateOfIssue : DateTime;
// 	dateOfReturn : DateTime;

// 	stuId : Association to one Students;
// }

// entity Marks  {
// 	subj : str20;
// 	marks : Integer;
// 	totMarks : Integer;
// 	percentage : Decimal;

// 	stuId : Association to one Students;
// }



// entity Albums  {
// 	key id : Integer;
// 	title : String(120) not null;
// 	description : String(255) not null;
// 	view : Integer not null;
// }

// entity Tags  {
// 	key id : Integer;
// 	title : String(120) not null;
// }

// entity TagPhotos  {
// 	key id : Integer;

// 	tag_id : Association to one Tags;
// 	photo_id : Association to one Photos;
// }

// entity Locations  {
// 	key id : Integer;
// 	name : String(200) not null;
// 	short_name : String(50) not null;
// }

// entity Photos  {
// 	key id : Integer;
// 	title : String(120) not null;
// 	description : String(255) not null;
// 	privacy : String(20) not null;
// 	upload_date : Date not null;
// 	view : Integer not null;
// 	img_path : String(50) not null;

// 	album_id : Association to one Albums;
// 	location_id : Association to one Locations;
// 	member_id : Association to one Members;
// }

// entity Comments  {
// 	key id : Integer;
// 	post_date : Date not null;
// 	content : String(255) not null;
	
// 	photo_id : Association to one Photos;
// }

// entity Members  {
// 	key id : Integer;
// 	name : String(255) not null;
// 	phone_number : String(20) not null;
// 	email : String(200) not null;
// 	address : String(255) not null;
// }

namespace firstapp;

using { cuid, Currency } from '@sap/cds/common';
using {firstapp.common as common} from './common';

context master {
    entity BusinessPartners {
        key NODE_KEY : common.Guid @(title : '{i18n>NODE_KEY}');
            BP_ROLE : common.Role @(title : '{i18n>BP_ROLE}');
            EMAIL : common.Email @(title : '{i18n>EMAIL}');
            MOBILE : common.PhoneNumber @(title : '{i18n>MOBILE}');
            FAX : common.String32 @(title : '{i18n>FAX}');
            WEB : common.String255 @(title : '{i18n>WEB}');
            BP_ID : common.Guid @(title : '{i18n>BP_ID}');
            COMPANY_NAME : common.String255 @(title : '{i18n>COMPANY_NAME}');
            // Managed Association
            AD : Association to Addresses;
    }

    entity Addresses : common.Address {
        key NODE_KEY : common.Guid @(title : '{i18n>NODE_KEY}');
            ADDRESS_TYPE : common.String32 @(title : '{i18n>ADDRESS_TYPE}');
            VAL_START : Date @(title : '{i18n>VAL_START}');
            VAL_END : Date @(title : '{i18n>VAL_END}');
            LATITUDE : Decimal(9, 6) @(title : '{i18n>LATITUDE}');
            LONGITUDE : Decimal(9, 6) @(title : '{i18n>LONGITUDE}');
            // Back-link Association
            BP : Association to one BusinessPartners on BP.AD = $self;
    }

    entity Products {
        key NODE_KEY : common.Guid @(title : '{i18n>NODE_KEY}');
            PRODUCT_ID : common.String32 @(title : '{i18n>PRODUCT_ID}');
            TYPE_CODE : String(2) @(title : '{i18n>TYPE_CODE}');
            CATEGORY : common.String32 @(title : '{i18n>CATEGORY}');
            DESCRIPTION : common.String255 @(title : '{i18n>DESCRIPTION}');
            TAX_TARIF_CODE : Integer @(title : '{i18n>TAX_TARIF_CODE}');
            MEASURE_UNIT : String(2) @(title : '{i18n>MEASURE_UNIT}');
            WEIGHT_MEASURE : Decimal(5, 2) @(title : '{i18n>WEIGHT_MEASURE}');
            WEIGHT_UNIT : String(2) @(title : '{i18n>WEIGHT_UNIT}');
            PRICE : Decimal(15, 2) @(title : '{i18n>PRICE}');
            CURRENCY_CODE : String(5) @(title : '{i18n>CURRENCY_CODE}');
            WIDTH : Decimal(5, 2) @(title : '{i18n>WIDTH}');
            DEPTH : Decimal(5, 2) @(title : '{i18n>DEPTH}');
            HEIGHT : Decimal(5, 2) @(title : '{i18n>HEIGHT}');
            DIM_UNIT : String(2) @(title : '{i18n>DIM_UNIT}');
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
        key NODE_KEY : common.Guid @(title : '{i18n>NODE_KEY}');
            PO_ID : common.Guid @(title : '{i18n>PO_ID}');
            // Managed Association
            PARTNER : Association to master.BusinessPartners;
            LIFECYCLE_STATUS : String(1) @(title : '{i18n>LIFECYCLE_STATUS}');
            OVERALL_STATUS : String(1) @(title : '{i18n>OVERALL_STATUS}');
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

entity Countries  {
    code : String(2);
    description : String(200);
}
