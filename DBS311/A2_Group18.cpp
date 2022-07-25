/*
--We(Juhee Lee, Seonhye Hyeon) declare that the attached assignment is our own work in
--accordance with the Seneca Academic Policy.
--No part of this assignment has been copied manually or electronically from any other source
--(including web sites) or distributed to other students.
-- * **********************
--Name: Juhee Lee
-- ID : 128261203
--Name : Seonhye Hyeon
-- ID : 125635193
--Date : November 28, 2021
--Purpose : Assignment2 DBS311
-- * **********************
*/
#include <iostream>
#include <string>
#include <occi.h>

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;
using namespace std;

constexpr int csize = 5;

struct ShoppingCart
{
	int product_id;
	double price;
	int quantity;
};

// The mainMenu() function returns an integer value which is the selected option by the user from the menu. 
int mainMenu()
{
	int option = 0;
	do
	{
		cout << "******************** Main Menu ********************" << endl;
		cout << "1)      Login" << endl;
		cout << "0)      Exit" << endl;
		
		if (option != 0 && option != 1)
		{
			cout << "You entered a wrong value. Enter an option (0-1): ";
		}
		else
		{
			cout << "Enter an option (0-1): ";
		}
		cin >> option;	
		
	} while (option != 0 && option != 1);

	return option;
}

// This function receives an integer value as a customer ID and checks if the customer does exist in the database
int customerLogin(Connection* conn, int customerId)
{
	int found = 0;

	Statement* stmt = conn->createStatement();
	stmt->setSQL("BEGIN find_customer(:1, :2); END;");
	stmt->setInt(1, customerId);
	stmt->registerOutParam(2, Type::OCCIINT, sizeof(found));
	stmt->executeUpdate();

	found = stmt->getInt(2);

	conn->terminateStatement(stmt);

	return found;
}

//This function receives an OCCI pointer (a reference variable to an Oracle database) and an integer value as the product ID.
double findProduct(Connection* conn, int product_id)
{
	double price = 0.0;
	Statement* stmt = conn->createStatement();

	// This functions calls the find_product() Oracle stored procedure
	// find_product (product_idd IN NUMBER, price OUT products.list_price%TYPE)
	stmt->setSQL("BEGIN find_product(:1, :2); END;");
	stmt->setInt(1, product_id);
	stmt->registerOutParam(2, Type::OCCIDOUBLE, sizeof(price));
	stmt->executeUpdate();
	price = stmt->getDouble(2);
	conn->terminateStatement(stmt);

	return price;
}

// This function receives an OCCI pointer (a reference variable to an Oracle database) and an array of type ShoppingCart. 
int addToCart(Connection* conn, struct ShoppingCart cart[])
{
	ShoppingCart sc;
	int pid;
	int i = 0;
	int qty;
	int num = 1;
	int itemNum = 0;

	cout << "-------------- Add Products to Cart --------------" << endl;
	while (i < csize && num) {

		bool check = false;

		while (!check)
		{
			cout << "Enter the product ID: ";
			cin >> pid;

			if (findProduct(conn, pid) == 0) {
				cout << "The product does not exist. Try again..." << endl;
			}
			else {
				check = true;
			}

		}

		cout << "Product Price: " << findProduct(conn, pid) << endl;

		bool qtycheck = false;

		while (!qtycheck) {
			cout << "Enter the product Quantity: ";
			cin >> qty;

			if (qty > 0) {
				qtycheck = true;
			}

		}

		sc.product_id = pid;
		sc.price = findProduct(conn, pid);
		sc.quantity = qty;

		cart[i] = sc;

		if (i < (csize - 1)) {//cart is not full		
			do {
				cout << "Enter 1 to add more products or 0 to checkout: ";
				cin >> num;

			} while (num != 0 && num != 1);

			if (num == 0) { itemNum = i + 1; } // user finished order
			else { i++; } // adding more products
		}
		else { // cart is full

			itemNum = csize;
		}
	}

	return itemNum;
}

// It display the product ID, price, and quantity for products stored in the cart array.
// Call this function after the function AddToCart() to display the products added by the user to the shopping cart.
void displayProducts(struct ShoppingCart cart[], int productCount)
{
	if (productCount > 0)
	{
		double total = 0.0;

		cout << "------- Ordered Products ---------" << endl;

		for (int i = 0; i < productCount; ++i) {

			cout << "---Item " << i + 1 << endl;
			cout << "Product ID: " << cart[i].product_id << endl;
			cout << "Price: " << cart[i].price << endl;
			cout << "Quantity: " << cart[i].quantity << endl;

			total += cart[i].price * cart[i].quantity;
		}

		cout << "----------------------------------" << endl;
		cout << "Total: " << total << endl;
	}
}

int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount)
{
	char yn;
	int result;

	do {
		cout << "Would you like to checkout? (Y/y or N/n) ";
		cin >> yn;

		if (yn != 'Y' && yn != 'y' && yn != 'N' && yn != 'n')
			cout << "Wrong input. Try again..." << endl;

	} while (yn != 'Y' && yn != 'y' && yn != 'N' && yn != 'n');

	if (yn == 'Y' || yn == 'y') {

		int oid;

		Statement* stmt = conn->createStatement();
		stmt->setSQL("BEGIN add_order(:1, :2); END;");
		stmt->setInt(1, customerId);
		stmt->registerOutParam(2, Type::OCCIINT, sizeof(oid));
		stmt->executeUpdate();

		oid = stmt->getInt(2);

		for (int i = 0; i < productCount; ++i)
		{
			stmt->setSQL("BEGIN add_order_item(:1, :2, :3, :4, :5); END; ");
			stmt->setInt(1, oid);
			stmt->setInt(2, i + 1);
			stmt->setInt(3, cart[i].product_id);
			stmt->setInt(4, cart[i].quantity);
			stmt->setDouble(5, cart[i].price);
			stmt->executeUpdate();
		}

		cout << "The order is successfully completed." << endl;
		conn->terminateStatement(stmt);
		result = 1;

	}
	else {//user chose canceled the order.

		cout << "The order is cancelled." << endl;
		result = 0;

	}
	return result;
}

int main()
{
	// OCCI variables
	Environment* env = nullptr;
	Connection* conn = nullptr;

	// Used variables
	string user = "dbs311_213za08";
	string pass = "98982187";
	string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";

	try
	{
		env = Environment::createEnvironment(Environment::DEFAULT);
		conn = env->createConnection(user, pass, constr);
		cout << "Connection is successful!" << endl;

		int menuNum;
		int cid;
		do {
			menuNum = mainMenu();

			if (menuNum)
			{
				cout << "Enter the customer ID: ";
				cin >> cid;

				if (!(customerLogin(conn, cid))) {
					cout << "The customer does not exist." << endl;

				}
				else {
					ShoppingCart cart[csize];
					int pcount = addToCart(conn, cart);
					displayProducts(cart, pcount);
					checkout(conn, cart, cid, pcount);
				}

			}
		} while (menuNum);

		cout << "Good bye!..." << endl;

		env->terminateConnection(conn);
		Environment::terminateEnvironment(env);
	}
	catch (SQLException& sqlExcp)
	{
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}

	return 0;
}