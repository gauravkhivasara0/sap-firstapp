// namespace firstapp.common;

// using { Country, Currency } from '@sap/cds/common';

// type str50 : String(50);

// type gender : String(20) enum {
//     M = 'Male';
//     F = 'Female';
// };

// type status : String(20) enum {
//     Approved;
//     Rejected;
//     Submitted;
//     Issue;
// }

// // Semantics
// type AmountType : Decimal(10, 2) @(
//     Semantics.amount.currencyCode: 'currency_code',
//     sap.unit: 'currency_code'
// );

// // regex
// type PhoneNumber : String(20) @assert.format : '^(?:(?:\+|00)?91[\-\s]?)?[6-9]\d{9}$';
// type Email : String(100) @assert.format : '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';

// aspect Address {
//     drno: str50;
//     street: str50;
//     landmark: str50;
//     city: str50;
//     postal: String(100);
//     state: String(100);
//     country: Country;
//     region: String(100);
// }

// aspect feeasp {
//     grossFee: AmountType;
//     tax: AmountType;
//     totalFee: AmountType;
//     currency: Currency;
// }

namespace firstapp.common;

using { Currency } from '@sap/cds/common';

type Guid : UUID;
type PhoneNumber : String(32);
type Email : String(255);
type Role : String(2);
type String32 : String(32);
type String64 : String(64);
type String255 : String(255);

type Gender : String(1) enum {
    male        = 'M';
    female      = 'F';
    undisclosed = 'D';
}

type AmountT : Decimal(10,2) @(
    Semantics.amount.currencyCode : 'CURRENCY_CODE',
    sap.unit : 'CURRENCY_CODE'
);

aspect Amount {
    GROSS_AMOUNT : AmountT;
    NET_AMOUNT   : AmountT;
    TAX_AMOUNT   : AmountT;
    CURRENCY     : Currency;
}

aspect Address {
    STREET      : String255;
    POSTAL_CODE : String(12);
    CITY        : String255;
    COUNTRY     : String255;
    BUILDING    : String255;
}
