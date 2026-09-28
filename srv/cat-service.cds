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
    entity PurchaseOrdersSrv as projection on database.transaction.PurchaseOrders {
        *
    } actions {
        // Instance bound actions
        action discountPrice() returns array of PurchaseOrdersSrv;

        // Instance bound function
        function largestOrder() returns array of PurchaseOrdersSrv;
    };

    entity PurchaseItemsSrv as projection on database.transaction.PurchaseItems;
    
    function getUtilities() returns String;
    
    function getHighestPricedProduct() returns array of ProductsSrv;
    
    // Custom function declaration
    function getHighestSalariedEmployees() returns array of EmployeesSrv;

    action createEmployee(
        ID: UUID,
        nameFirst: common.String64,
        nameLast: common.String64,
        nameMiddle: common.String64,
        nameInitials: common.String64,
        gender: common.Gender,
        language: String(2),
        loginName: String(16),
        phoneNumber: common.PhoneNumber,
        email: common.Email,
        Currency_code: String(3),
        salaryAmount: common.AmountT,
        accountNumber: common.String32,
        bankId: String(16),
        bankName: common.String64
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
