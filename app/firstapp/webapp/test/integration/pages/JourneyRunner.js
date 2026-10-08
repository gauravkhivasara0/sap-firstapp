sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"firstapp/test/integration/pages/PurchaseOrdersSrvList.gen",
	"firstapp/test/integration/pages/PurchaseOrdersSrvObjectPage.gen",
	"firstapp/test/integration/pages/PurchaseItemsSrvObjectPage.gen"
], function (JourneyRunner, PurchaseOrdersSrvListGenerated, PurchaseOrdersSrvObjectPageGenerated, PurchaseItemsSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('firstapp') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrdersSrvListGenerated: PurchaseOrdersSrvListGenerated,
			onThePurchaseOrdersSrvObjectPageGenerated: PurchaseOrdersSrvObjectPageGenerated,
			onThePurchaseItemsSrvObjectPageGenerated: PurchaseItemsSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

