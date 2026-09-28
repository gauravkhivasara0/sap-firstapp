const cds = require('@sap/cds-dk/lib/cds');
const INSERT = require('@sap/cds/lib/ql/INSERT');
const { uuid, exists, isdir, mkdirp, read } = cds.utils;

module.exports = cds.service.impl(async function() {
    // Declare Employee service from entities
    const {
        EmployeesSrv,
        AddressesSrv,
        ProductsSrv,
        PurchaseItemsSrv,
        BusinessPartnersSrv,
        PurchaseOrdersSrv
    } = this.entities;

    // Utility Variables
    this.on('getUtilities', async (request, response) => {
        let UUID = uuid();
        let input = null;
        let uri;
        
        const doesFileExist = exists('srv/request.http');
        const dirExists = isdir('app');
        const packageContent = await read('package.json');

        try {
            uri = decodeURI(input);
            await mkdirp('srv/handlers');
        } catch {
            uri = input;
        }

        const finalValue = {
            UUID,
            uri,
            doesFileExist,
            dirExists,
            packageContent
        };

        return finalValue;
    });
    
    this.on('getTopHighestPaid', async (request, response) => {
        try {
            const transaction = cds.tx(request);

            const returnData = await transaction.read(EmployeesSrv).orderBy({
                salaryAmount: 'desc'
            }).limit(20);

            return returnData;
        } catch (err) {
            return 'Error: ' + err.toString();
        }
    })
    
    this.on('incrementSalary', async (request, response) => {
        try {
            const ID = request.params[0];
            const transaction = cds.tx(request);

            await transaction.update(EmployeesSrv).with({
                salaryAmount: { '*=' : 1.15 }
            }).where(ID);

            const updatedData = await transaction.read(EmployeesSrv);

            return updatedData;
        } catch (err) {
            return 'Error: ' + err.toString();
        }
    });

    // Handling instance bound function
    this.on('largestOrder', async (request, response) => {
        try {
            const transaction = cds.tx(request);

            const returnData = await transaction.read(PurchaseOrdersSrv).orderBy({
                GROSS_AMOUNT: 'desc'
            }).limit(5);

            return returnData;
        } catch (err) {
            return 'Error: ' + err.toString();
        }
    })
    
    // Handling instance bound action
    this.on('discountPrice', async (request, response) => {
        try {
            const ID = request.params[0];
            const transaction = cds.tx(request);

            await transaction.update(PurchaseOrdersSrv).with({
                GROSS_AMOUNT: { '-=' : 1000 },
                NET_AMOUNT: { '-=' : 800 },
                TAX_AMOUNT: { '-=' : 200 }
            }).where(ID);

            const updatedData = await transaction.read(PurchaseOrdersSrv);

            return updatedData;
        } catch (err) {
            return 'Error: ' + err.toString();
        }
    });
    
    this.on('getHighestPricedProduct', async (request, response) => {
        try {
            const transaction = cds.tx(request);

            const returnData = await transaction.read(ProductsSrv).orderBy({
                PRICE: 'desc'
            }).limit(10);

            return returnData;
        } catch (err) {
            request.error('Error: ' + err);
        }
    });

    // Implementation of custom function
    this.on('getHighestSalariedEmployees', async (request, response) => {
        try {
            const transaction = cds.tx(request);

            const returnData = await transaction.read(EmployeesSrv).orderBy({
                salaryAmount: 'desc'
            }).limit(10);

            return returnData;
        } catch (err) {
            request.error('Error: ', err);
        }
    });

    this.before('UPDATE', PurchaseItemsSrv, async (request, response) => {
        const poItemsPosition = request.data.PO_ITEM_POS;

        if (parseInt(poItemsPosition, 10) % 10 !== 0) {
            request.error(500, 'Invalid item position');
        }
    });
    
    this.before('UPDATE', BusinessPartnersSrv, async (request, response) => {
        const companyName = String(request.data.COMPANY_NAME);

        if (companyName.includes('.') || companyName.includes('-') || companyName.contains(',')) {
            request.error(500, 'Invalid company name');
        }
    });
    
    this.before('UPDATE', EmployeesSrv, async (request, response) => {
        const phoneNumber = String(request.data.PHONENUMBER);

        if (!phoneNumber.startsWith('+1') && !phoneNumber.startsWith('+44')) {
            request.error(500, 'Unable to update phone number');
        }
    });
    
    this.before('UPDATE', AddressesSrv, async (request, response) => {
        const country = request.data.COUNTRY;

        if (country !== 'US' && country !== 'GB') {
            request.error(500, 'Please contact you administrator');
        }
    });
    
    this.before('UPDATE', PurchaseItemsSrv, async (request, response) => {
        const { GROSS_AMOUNT, CURRENCY_code } = request.data;

        if (CURRENCY_code === 'USD' && GROSS_AMOUNT > 15000) {
            console.log('US');
            request.error(500, 'Please get in touch with your line manager');
        // } else if (CURRENCY_code === 'EUR' && GROSS_AMOUNT > 10000) {
        //     console.log('EUR');
        //     request.error(500, 'Please check with your regional manager');
        }
    });
    
    this.before('UPDATE', ProductsSrv, async (request, response) => {
        const price = request.data.PRICE;

        if (price > 5000) {
            request.error(500, 'To update the price above 5000.00, please get an approval from your line manager.')
        }
    });
    
    this.before('UPDATE', EmployeesSrv, async (request, response) => {
        const { salaryAmount } = request.data;

        if (salaryAmount > 100000) {
            request.error(500, 'Please get an approval from your line manager.');
        }
    });

    this.on('createEmployee', async (request, response) => {
        // Get data from the request
        const empData = request.data;

        // Instantiate the transaction object
        const transaction = cds.tx(request);

        // Insert data into DB
        let returnData = await transaction.run([
            INSERT.into(EmployeesSrv).entries(empData)
        ]).then((resolve, reject) => {
            if (typeof resolve !== undefined) {
                return empData;
            } else {
                request.reject(500, 'An error occured while inserting data into DB.');
            }
        }).catch((err) => {
            request.error('An error occured:', err.toString());
        });
        
        // Return data on success
        return returnData;
    });
    
    this.on('createAddress', async (request, response) => {
        const addressData = request.data;
        
        const transaction = cds.tx(request);
        
        let returnData = await transaction.run([
            INSERT.into(AddressesSrv).entries(addressData)
        ]).then((resolve, reject) => {
            if (typeof resolve !== undefined) {
                return addressData;
            } else {
                request.reject(500, 'An error occured while inserting data into DB.');
            }
        }).catch((err) => {
            request.error('An error occured:', err.toString());
        });

        return returnData;
    });

    this.on('updateEmployee', async (request, response) => {
        const { ID, salaryAmount, Currency_code } = request.data;

        try {
            const transaction = cds.tx(request);

            await transaction.update(EmployeesSrv).with({
                salaryAmount,
                Currency_code
            }).where({
                ID
            });

            return 'Update successful!';
        } catch (err) {
            request.error('An error occured:', err.toString());
        }
    });

    this.on('updateAddress', async (request, response) => {
        const { NODE_KEY, ADDRESS_TYPE, CITY } = request.data;

        try {
            const transaction = cds.tx(request);

            await transaction.update(AddressesSrv).with({
                ADDRESS_TYPE,
                CITY
            }).where({
                NODE_KEY
            });

            return 'Update successful!';
        } catch (err) {
            request.error('An error occured:', err.toString());
        }
    });

    this.on('createProduct', async (request, response) => {
        const prodData = request.data;

        const transaction = cds.tx(request);

        let returnData = await transaction.run([
            INSERT.into(ProductsSrv).entries(prodData)
        ]).then((resolve, reject) => {
            if (typeof resolve !== undefined) {
                return prodData;
            } else {
                request.reject(500, 'An error occured while inserting data.');
            }
        }).catch((err) => {
            request.error(500, 'An error occured:', err.toString());
        });

        return returnData;
    });

    this.on('updateProduct', async (request, response) => {
        const { NODE_KEY, PRICE, CURRENCY_CODE } = request.data;

        try {
            const transaction = cds.tx(request);

            await transaction.update(ProductsSrv).with({
                PRICE,
                CURRENCY_CODE
            }).where({
                NODE_KEY
            });

            return 'Update successful!';
        } catch (err) {
            request.error('An error occured:', err.toString());
        }
    });

    this.on('deleteAddress', async (request, response) => {
        const { NODE_KEY } = request.data;

        try {
            const transaction = cds.tx(request);

            await transaction.delete(AddressesSrv).where({
                NODE_KEY
            });

            return 'Deleted successfully!';
        } catch (err) {
            request.error('An error occured:', err.toString());
        }
    });
});
