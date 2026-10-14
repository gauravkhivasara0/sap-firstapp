// using CatalogService as service from '../../srv/cat-service';
// annotate service.PurchaseOrdersSrv with @(
//     UI.FieldGroup #GeneratedGroup : {
//         $Type : 'UI.FieldGroupType',
//         Data : [
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'GROSS_AMOUNT',
//                 Value : GROSS_AMOUNT,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'NET_AMOUNT',
//                 Value : NET_AMOUNT,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'TAX_AMOUNT',
//                 Value : TAX_AMOUNT,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'CURRENCY_code',
//                 Value : CURRENCY_code,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'LIFECYCLE_STATUS',
//                 Value : LIFECYCLE_STATUS,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Label : 'OVERALL_STATUS',
//                 Value : OVERALL_STATUS,
//             },
//         ],
//     },
//     UI.Facets : [
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID : 'GeneratedFacet1',
//             Label : 'General Information',
//             Target : '@UI.FieldGroup#GeneratedGroup',
//         },
//     ],
//     UI.LineItem : [
//         {
//             $Type : 'UI.DataField',
//             Label : 'GROSS_AMOUNT',
//             Value : GROSS_AMOUNT,
//         },
//         {
//             $Type : 'UI.DataField',
//             Label : 'NET_AMOUNT',
//             Value : NET_AMOUNT,
//         },
//         {
//             $Type : 'UI.DataField',
//             Label : 'TAX_AMOUNT',
//             Value : TAX_AMOUNT,
//         },
//         {
//             $Type : 'UI.DataField',
//             Label : 'CURRENCY_code',
//             Value : CURRENCY_code,
//         },
//         {
//             $Type : 'UI.DataField',
//             Label : 'LIFECYCLE_STATUS',
//             Value : LIFECYCLE_STATUS,
//         },
//     ],
// );

// annotate service.PurchaseOrdersSrv with {
//     PARTNER @Common.ValueList : {
//         $Type : 'Common.ValueListType',
//         CollectionPath : 'BusinessPartnersSrv',
//         Parameters : [
//             {
//                 $Type : 'Common.ValueListParameterInOut',
//                 LocalDataProperty : PARTNER_NODE_KEY,
//                 ValueListProperty : 'NODE_KEY',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'BP_ROLE',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'EMAIL',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'MOBILE',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'FAX',
//             },
//         ],
//     }
// };

using CatalogService as service from '../../srv/cat-service';

annotate service.PurchaseOrdersSrv with @(
    UI.SelectionFields : [
        PO_ID,
        COMPANY_NAME,
        GROSS_AMOUNT,
        PARTNER,
        partnerCountryDesc
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : PO_ID
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.EntityContainer/createEmployee',
            Label : 'Create Employee'
        },
        {
            $Type : 'UI.DataField',
            Value : COMPANY_NAME
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.discountPrice',
            Label : 'Discount',
            Inline : true
        },
        {
            $Type : 'UI.DataField',
            Value : LSTEXT,
            Criticality : LSC
        },
        {
            $Type : 'UI.DataField',
            Value : OSTEXT,
            Criticality : OSC
        },
        {
            $Type : 'UI.DataField',
            Value : partnerCountryDesc
        }
    ]
);

