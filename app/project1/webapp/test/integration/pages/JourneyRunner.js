sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/customersList",
	"project1/test/integration/pages/customersObjectPage"
], function (JourneyRunner, customersList, customersObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onThecustomersList: customersList,
			onThecustomersObjectPage: customersObjectPage
        },
        async: true
    });

    return runner;
});

