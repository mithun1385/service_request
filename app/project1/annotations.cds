using serviceHandler as sh from '../../srv/cat-service';

// ══════════════════════════════════════════════════
// VALUE LISTS — dropdown options
// ══════════════════════════════════════════════════

// Customer Status dropdown
annotate sh.customers with {
    status @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            CollectionPath: 'customers',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'status'
                }
            ]
        }
    );
}

// Order Status dropdown
annotate sh.orders with {
    status @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            CollectionPath: 'orders',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'status'
                }
            ]
        }
    );
}

// Product Status dropdown
annotate sh.products with {
    status @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            CollectionPath: 'products',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'status'
                }
            ]
        }
    );
}

// Service Request Priority dropdown
annotate sh.serviceRequests with {
    priority @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            CollectionPath: 'serviceRequests',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'priority'
                }
            ]
        }
    );

    // Service Request Status dropdown
    status @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            CollectionPath: 'serviceRequests',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'status'
                }
            ]
        }
    );
}

// ══════════════════════════════════════════════════
// CLOSE TICKET — status param dropdown (single column)
// ══════════════════════════════════════════════════

annotate sh.serviceRequests actions {
    closeTicket(
        status @(
            title                          : 'Status',
            Common.ValueListWithFixedValues: true,
            Common.ValueList               : {
                CollectionPath: 'serviceValueStatus',
                Parameters    : [
                    {
                        $Type             : 'Common.ValueListParameterOut',
                        LocalDataProperty : status,
                        ValueListProperty : 'code'
                    }
                ]
            }
        )
    );
}


// ══════════════════════════════════════════════════
// CUSTOMERS — List Report + Object Page
// ══════════════════════════════════════════════════

annotate sh.customers with @(
    UI.LineItem: [
        { Value: customerName, Label: 'Customer Name' },
        { Value: email,        Label: 'Email'         },
        { Value: phone,        Label: 'Phone'         },
        { Value: city,         Label: 'City'          },
        { Value: status,       Label: 'Status'        }
    ]
);

annotate sh.customers with @(
    UI.HeaderInfo: {
        TypeName      : 'Customer',
        TypeNamePlural: 'Customers',
        Title         : { Value: customerName },
        Description   : { Value: email }
    }
);

annotate sh.customers with @(

    // ── filter bar dropdowns on List Report ──
    UI.SelectionFields: [ status ],

    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Information',
            Target: '@UI.FieldGroup#General'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Orders',
            Target: 'orders/@UI.LineItem'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Service Requests',
            Target: 'serviceRequests/@UI.LineItem'
        }
    ],
    UI.FieldGroup#General: {
        Data: [
            { Value: customerName, Label: 'Customer Name' },
            { Value: email,        Label: 'Email'         },
            { Value: phone,        Label: 'Phone'         },
            { Value: city,         Label: 'City'          },
            { Value: status,       Label: 'Status'        }
        ]
    },
    UI.Identification: [
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Place Order',
            Action: 'serviceHandler.placeOrder'
        }
    ]
);


// ══════════════════════════════════════════════════
// ORDERS — sub-table + Object Page
// ══════════════════════════════════════════════════

annotate sh.orders with @(
    UI.LineItem: [
        { Value: orderDate,   Label: 'Order Date'   },
        { Value: status,      Label: 'Status'       },
        { Value: totalAmount, Label: 'Total Amount' },
        { Value: createdAt,   Label: 'Created At'   },
        { Value: modifiedAt,  Label: 'Modified At'  },
        { Value: modifiedBy,  Label: 'Modified By'  },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Approve Order',
            Action: 'serviceHandler.approveOrder'
        }
    ]
);

annotate sh.orders with @(

    // ── filter bar dropdowns on Orders List Report ──
    UI.SelectionFields: [ status ],

    UI.HeaderInfo: {
        TypeName      : 'Order',
        TypeNamePlural: 'Orders',
        Title         : { Value: status },
        Description   : { Value: orderDate }
    },
    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Order Details',
            Target: '@UI.FieldGroup#OrderDetails'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Order Items',
            Target: 'items/@UI.LineItem'
        }
    ],
    UI.FieldGroup#OrderDetails: {
        Data: [
            { Value: orderDate,   Label: 'Order Date'   },
            { Value: totalAmount, Label: 'Total Amount' },
            { Value: status,      Label: 'Status'       }
        ]
    },
    UI.Identification: [
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Approve Order',
            Action: 'serviceHandler.approveOrder'
        }
    ]
);


// ══════════════════════════════════════════════════
// ORDER ITEMS
// ══════════════════════════════════════════════════

annotate sh.orderItems with @(
    UI.LineItem: [
        { Value: product.productName, Label: 'Product'    },
        { Value: quantity,            Label: 'Quantity'   },
        { Value: unitPrice,           Label: 'Unit Price' },
        { Value: lineTotal,           Label: 'Line Total' }
    ]
);


// ══════════════════════════════════════════════════
// PRODUCTS — List Report + Object Page
// ══════════════════════════════════════════════════

annotate sh.products with @(
    UI.LineItem: [
        { Value: productName, Label: 'Product Name' },
        { Value: category,    Label: 'Category'     },
        { Value: price,       Label: 'Price'        },
        { Value: stock,       Label: 'Stock'        },
        { Value: status,      Label: 'Status'       },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Add Stock',
            Action: 'serviceHandler.addStock'
        }
    ]
);

annotate sh.products with @(

    // ── filter bar dropdowns on Products List Report ──
    UI.SelectionFields: [ category, status ],

    UI.HeaderInfo: {
        TypeName      : 'Product',
        TypeNamePlural: 'Products',
        Title         : { Value: productName },
        Description   : { Value: category }
    },
    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Product Details',
            Target: '@UI.FieldGroup#ProductDetails'
        }
    ],
    UI.FieldGroup#ProductDetails: {
        Data: [
            { Value: productName, Label: 'Product Name' },
            { Value: category,    Label: 'Category'     },
            { Value: price,       Label: 'Price'        },
            { Value: stock,       Label: 'Stock'        },
            { Value: status,      Label: 'Status'       }
        ]
    },
    UI.Identification: [
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Add Stock',
            Action: 'serviceHandler.addStock'
        }
    ]
);


// ══════════════════════════════════════════════════
// SERVICE REQUESTS — sub-table + Object Page
// ══════════════════════════════════════════════════

annotate sh.serviceRequests with @(
    UI.LineItem: [
        { Value: issue,      Label: 'Issue'       },
        { Value: priority,   Label: 'Priority'    },
        { Value: status,     Label: 'Status'      },
        { Value: assignedTo, Label: 'Assigned To' },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Close Ticket',
            Action: 'serviceHandler.closeTicket'
        }
    ]
);

annotate sh.serviceRequests with @(

    // ── filter bar dropdowns on ServiceRequests List Report ──
    UI.SelectionFields: [ priority, status ],

    UI.HeaderInfo: {
        TypeName      : 'Service Request',
        TypeNamePlural: 'Service Requests',
        Title         : { Value: issue },
        Description   : { Value: status }
    },
    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Ticket Details',
            Target: '@UI.FieldGroup#TicketDetails'
        }
    ],
    UI.FieldGroup#TicketDetails: {
        Data: [
            { Value: issue,      Label: 'Issue'       },
            { Value: priority,   Label: 'Priority'    },
            { Value: status,     Label: 'Status'      },
            { Value: assignedTo, Label: 'Assigned To' }
        ]
    },
    UI.Identification: [
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Close Ticket',
            Action: 'serviceHandler.closeTicket'
        }
    ]
);
