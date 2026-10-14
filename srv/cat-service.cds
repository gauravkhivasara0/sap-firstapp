using { firstapp as database } from '../db/schema';
using { firstapp.common as common } from '../db/common';

// adding comment to test temp branch

service CatalogService {
    // Master data (Master context)
    entity BusinessPartnersSrv as projection on database.master.BusinessPartners;

    entity AddressesSrv as projection on database.master.Addresses;

    entity ProductsSrv as projection on database.master.Products;

    // @insertonly
    entity EmployeesSrv as projection on database.master.Employees {
        *
    } actions {
        action incrementSalary() returns array of EmployeesSrv;

        function getTopHighestPaid() returns array of EmployeesSrv;
    };

    // Transactional data (Transaction context)
    entity PurchaseOrdersSrv as 
        select from database.transaction.PurchaseOrders as po
        inner join database.master.BusinessPartners as bp on bp.NODE_KEY = po.PARTNER.NODE_KEY
        inner join database.master.Addresses as ad on ad.NODE_KEY = bp.AD.NODE_KEY
        inner join database.Countries as country on ad.COUNTRY = country.code
    {
        key po.NODE_KEY,
        po.PO_ID,
        po.GROSS_AMOUNT,
        po.NET_AMOUNT,
        po.TAX_AMOUNT,
        po.CURRENCY,
        bp.COMPANY_NAME,
        bp.BP_ID,
        bp.BP_ROLE,
        bp.MOBILE,
        bp.FAX,
        bp.EMAIL,
        bp.WEB,
        ad.ADDRESS_TYPE,
        ad.BUILDING,
        ad.CITY,
        ad.COUNTRY,
        ad.LATITUDE,
        ad.LONGITUDE,
        ad.STREET,
        ad.POSTAL_CODE,
        po.Items,
        bp.COMPANY_NAME as partnerName,
        bp.BP_ID as partnerID,
        ad.COUNTRY as partnerCountry,
        country.description as partnerCountryDesc @(title : '{i18n>COUNTRY}'),
        case LIFECYCLE_STATUS
            when 'N' then 'Not started'
            when 'S' then 'Started'
            when 'C' then 'Completed'
            else 'Cancelled'
        end as LSTEXT : String(20) @(title: '{i18n>LIFECYCLE_STATUS}'),
        case OVERALL_STATUS
            when 'R' then 'Returned'
            when 'P' then 'Processed'
            when 'D' then 'Delievered'
            else 'New'
        end as OSTEXT : String(20) @(title: '{i18n>OVERALL_STATUS}'),
        case LIFECYCLE_STATUS
            when 'N' then 2
            when 'S' then 3
            when 'C' then 3
            else 1
        end as LSC : Integer,
        case OVERALL_STATUS
            when 'R' then 1
            when 'P' then 3
            when 'D' then 3
            else 2
        end as OSC : Integer
    } actions {
        // Instance bound actions
        // DB ops won't work on a view
        action discountPrice() returns array of PurchaseOrdersSrv;

        // Instance bound function
        function largestOrder() returns array of PurchaseOrdersSrv;
    };

    // Added as DB ops won't work on views
    // action discountPrice() returns array of PurchaseOrdersSrv;

    entity PurchaseItemsSrv as projection on database.transaction.PurchaseItems;
    
    function getUtilities() returns String;
    
    function getHighestPricedProduct() returns array of ProductsSrv;
    
    // Custom function declaration
    function getHighestSalariedEmployees() returns array of EmployeesSrv;

    action createEmployee(
        nameFirst: common.String64 @(title : '{i18n>EMP_FIRST_NAME}'),
        nameLast: common.String64 @(title : '{i18n>EMP_LAST_NAME}'),
        nameMiddle: common.String64 @(title : '{i18n>EMP_MIDDLE_NAME}'),
        nameInitials: common.String64 @(title : '{i18n>EMP_INITIALS}'),
        gender: common.Gender @(title : '{i18n>EMP_GENDER}'),
        language: String(2) @(title : '{i18n>EMP_LANG}'),
        loginName: String(16) @(title : '{i18n>EMP_LOGIN_NAME}'),
        phoneNumber: common.PhoneNumber @(title : '{i18n>EMP_PHONE_NUM}'),
        email: common.Email @(title : '{i18n>EMP_EMAIL}'),
        Currency_code: String(3) @(title : '{i18n>CURRENCY_CODE}'),
        salaryAmount: common.AmountT @(title : '{i18n>EMP_SALARY_AMOUNT}'),
        accountNumber: common.String32 @(title : '{i18n>EMP_ACC_NUM}'),
        bankId: String(16) @(title : '{i18n>EMP_BANK_ID}'),
        bankName: common.String64 @(title : '{i18n>EMP_BANK_NAME}')
    ) returns array of EmployeesSrv;

    action createAddress(
        STREET: common.String255,
        POSTAL_CODE: String(12),
        CITY: common.String255,
        COUNTRY: common.String255,
        BUILDING: common.String255,
        ID: UUID,
        ADDRESS_TYPE: common.String32,
        VAL_START: Date,
        VAL_END: Date,
        LATITUDE: Decimal(9, 6),
        LONGITUDE: Decimal(9, 6),
        BUSINESS_PARTNERS_ID: UUID
    ) returns array of AddressesSrv;
    
    action updateEmployee(
        ID: UUID,
        salaryAmount: common.AmountT,
        Currency_code: String(3)
    ) returns String;

    action updateAddress(
        NODE_KEY: UUID,
        ADDRESS_TYPE: common.String32,
        CITY: String
    ) returns String;

    action createProduct(
        NODE_KEY: UUID,
        PRODUCT_ID: common.String32,
        TYPE_CODE: String(2),
        CATEGORY: common.String32,
        DESCRIPTION: common.String255,
        TAX_TARIF_CODE: Integer,
        MEASURE_UNIT: String(2),
        WEIGHT_MEASURE: Decimal(5, 2),
        WEIGHT_UNIT: String(2),
        PRICE: Decimal(15, 2),
        CURRENCY_CODE: String(5),
        WIDTH: Decimal(5, 2),
        DEPTH: Decimal(5, 2),
        HEIGHT: Decimal(5, 2),
        DIM_UNIT: String(2),
        SUPPLIERS_BUSINESS_PARTNER_NODE_KEY: UUID
    ) returns array of ProductsSrv;

    action updateProduct(
        NODE_KEY: UUID,
        PRICE: Decimal(15, 2),
        CURRENCY_CODE: String(5)
    ) returns String;

    action deleteAddress(
        NODE_KEY: UUID
    ) returns String;
}
