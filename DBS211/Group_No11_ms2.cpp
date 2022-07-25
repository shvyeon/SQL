/*
* Group No: 11
* Name: Tien Thanh Pham
* Student ID: 124150202
* Name: Hoang Giang Ta
* Student ID: 121854202
* Name: Seonhye Hyeon
* Student ID: 125635193
*/
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <occi.h>
#include <string>
#include <cstring>

using oracle::occi::Environment;
using oracle::occi::Connection;

using namespace oracle::occi;
using namespace std;
#define BLOCK_SIZE 30 
//Data structure:
// 
typedef struct Employee
{
    int  employeeNumber;
    char lastName[50];
    char firstName[50];
    char extension[10];
    char email[100];
    char officecode[10];
    int  reportsTo;
    char jobTitle[50];
} Employee;

//protorype...
void displayAllEmployees(Connection* conn);
int findEmployee(Connection* conn, int employeeNumber, struct Employee* emp);
void displayEmployee(Connection* conn, struct Employee* emp);
int menu();
void updateEmployee(Connection* conn, int employeeNumber);
void deleteEmployee(Connection* conn, int employeeNumber);
void getEmployee(struct Employee* emp);
void insertEmployee(Connection* conn, struct Employee emp);

/*********************************************************************/
//global variable    
Employee g_employee;
/*********************************************************************/
int main(void)
{
    Environment* env = nullptr;
    Connection* conn = nullptr;
    Statement* stmt = nullptr;
    ResultSet* rs = nullptr;
    string user = "dbs211_212za32";
    string pass = "94903137";
    string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";
    Employee employee = {};
    try {

        env = Environment::createEnvironment(Environment::DEFAULT);
        conn = env->createConnection(user, pass, constr);
        int inputnumber = -1;
        bool terminate = false;
        while (!terminate)
        {
            switch (menu())
            {
            case 1: displayEmployee(conn, &employee); break;
            case 2: displayAllEmployees(conn); break;
            case 3: 
                getEmployee(&employee);
                insertEmployee(conn, employee);
                break;
            case 4:
                int empNum;
                cout << "Enter EmployNumber: ";
                cin >> empNum;
                updateEmployee(conn, empNum);
                break;
            case 5:
                cout << "Enter EmployNumber: ";
                cin >> empNum;
                deleteEmployee(conn, empNum);
                break;
            default: terminate = true;
                break;
            }
        }

        env->terminateConnection(conn);
        Environment::terminateEnvironment(env);
    }
    catch (SQLException& sqlExcp) {
        cout << "error";
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
    }

    return 0;
}
int menu()
{
    int selection = 0;
    std::cout << "******************** HR Menu ********************" << std::endl;
    std::cout << "1) Find Employee\n2) Employees Report\n3) Add Employee\n4) Update Employee\n5) Remove Employee\n0) Exit" << std::endl;
    std::cout << "Enter an option (0-5): ";

    while (std::cin >> selection)
    {
        if (selection > 5 || selection < 0)
        {
            std::cout << "Invalid option [0 <= value <= 5]: ";
        }
        else
        {
            break;
        }
    }

    return selection;
}


void displayAllEmployees(Connection* conn)
{
    Statement* stmt = conn->createStatement("SELECT e.employeenumber,   e.firstname || ' ' || e.lastname,  e.email,  o.phone,  e.extension, em.firstname || ' ' || em.lastname  FROM employees e LEFT JOIN employees em ON e.reportsto = em.employeenumber JOIN offices o ON e.officecode = o.officecode ORDER BY e.employeenumber ");
    ResultSet* rs = stmt->executeQuery();
    int employeeNumber;
    char name[50];
    char email[50];
    char phoneNumber[50];
    char extension[50];
    char manager[50];
    int length = 0;
    int counter = 0;
    bool showHeader = true;

    while (rs->next())
    {
        if (showHeader)
        {
            cout << "-----" << "  " << "-----------------" << "  " << "-----------------------------------" << "  " << "-----------------" << "  " << "----------" << "  " << "------------------" << endl;

            cout << "ID   " << "  " << "Employee Name    " << "  " << "Email                              " << "  " << " Phone           " << "  " << "Extension " << "  " << "Manager Name      " << endl;
            cout << "-----" << "  " << "-----------------" << "  " << "-----------------------------------" << "  " << "-----------------" << "  " << "----------" << "  " << "------------------" << endl;
            showHeader = false;
        }
        employeeNumber = rs->getInt(1);
        strcpy(name, rs->getString(2).c_str());
        strcpy(email, rs->getString(3).c_str());
        strcpy(phoneNumber, rs->getString(4).c_str());
        strcpy(extension, rs->getString(5).c_str());
        strcpy(manager, rs->getString(6).c_str());
        cout.width(5);
        cout.setf(ios::left);
        cout << employeeNumber << "  ";
        cout.width(18);
        cout << name << " ";
        cout.width(35);
        cout << email << "  ";
        cout.width(17);
        cout << phoneNumber << "  ";
        cout.width(9);
        cout << extension << "   ";
        cout.width(18);
        cout << manager << "" << endl;
        counter++;
    }
    if (!counter)
    {
        cout << "\nThere is no employee's information to be displayed.\n" << endl;
    }
    conn->terminateStatement(stmt);
}

int findEmployee(Connection* conn, int employeeNumber, struct Employee* emp)
{
    int flag = 1;
    Statement* stmt = conn->createStatement("SELECT * FROM employees WHERE employees.employeenumber = :1");
    stmt->setInt(1, employeeNumber);
    ResultSet* rs = stmt->executeQuery();

    rs = stmt->executeQuery();

    if (!rs->next())
    {
        flag = 0;
    }
    else
    {
        emp->employeeNumber = rs->getInt(1);
        strncpy(emp->lastName, rs->getString(2).c_str(), sizeof(emp->lastName));
        strncpy(emp->firstName, rs->getString(3).c_str(), sizeof(emp->firstName));
        strncpy(emp->extension, rs->getString(4).c_str(), sizeof(emp->extension));
        strncpy(emp->email, rs->getString(5).c_str(), sizeof(emp->email));
        sprintf(emp->officecode, "%d", rs->getInt(6));
        if (rs->isNull(7) == false)
        {
            emp->reportsTo = rs->getInt(7);
        }
        else
        {
            //cout << 0;
        }
        strncpy(emp->jobTitle, rs->getString(8).c_str(), sizeof(emp->jobTitle));
        conn->terminateStatement(stmt);
        flag = 1;
    }
    return flag;
}


void displayEmployee(Connection* conn, struct Employee* emp)
{
    int empNum;
    cout << "Enter EmployNumber: ";
    cin >> empNum;
    int find = findEmployee(conn, empNum, emp);
    if (find == 1)
    {
        cout << endl << "-------------- Employee Information -------------" << endl;
        cout << "Employee Number: " << emp->employeeNumber << endl;
        cout << "Last Name: " << emp->lastName << endl;
        cout << "First Name: " << emp->firstName << endl;
        cout << "Extension: " << emp->extension << endl;
        cout << "Email: " << emp->email << endl;
        cout << "Office Code: " << emp->officecode << endl;
        cout << "Manager ID: " << emp->reportsTo << endl;
        cout << "Job Title: " << emp->jobTitle << endl << endl;
    }
    else
    {
        cout << "Employee " << empNum << " dose not exit.\n";
    }
}
void updateEmployee(Connection* conn, int employeeNumber)
{
    if (findEmployee(conn, employeeNumber, &g_employee))
    {
        char extension[10];
        cout << "Last Name: " << g_employee.lastName << endl;
        cout << "First Name: " << g_employee.firstName << endl;
        cout << "Extension: ";
        cin >> extension;
        if (extension) strcpy(g_employee.extension, extension);
        Statement* stmt = conn->createStatement("UPDATE employees e SET e.extension = :1 WHERE e.employeenumber = :2 ");
        stmt->setString(1, g_employee.extension);
        stmt->setInt(2, g_employee.employeeNumber);
        stmt->executeUpdate();
        conn->commit();
        conn->terminateStatement(stmt);
        cout << "The employee's extension is updated successfully." << endl << endl;
    }
    else
    {
        cout << "The employee with ID " << employeeNumber << " does not exit.\n";
    }
}
void deleteEmployee(Connection* conn, int employeeNumber)
{
    if (findEmployee(conn, employeeNumber, &g_employee))
    {
        Statement* stmt = conn->createStatement("DELETE FROM employees e WHERE e.employeenumber = :1 ");
        stmt->setInt(1, g_employee.employeeNumber);
        stmt->executeUpdate();
        conn->commit();
        conn->terminateStatement(stmt);
        cout << "The employee with ID " << g_employee.employeeNumber << " is deleted successfully." << endl << endl;
    }
    else
    {
        cout << "The employee with ID " << employeeNumber << " does not exit.\n";
    }
}

void getEmployee(struct Employee* emp)
{
    int officeCode = 1, managerID = 1002;

    cout << "-------------- New Employee Information -------------" << endl;
    cout << "Employee Number: ";
    cin >> emp->employeeNumber;
    cout << "Last Name: ";
    cin >> emp->lastName;
    cout << "First Name: ";
    cin >> emp->firstName;
    cout << "Extension: ";
    cin >> emp->extension;
    cout << "Email: ";
    cin >> emp->email;
    cout << "Office Code: " << officeCode << endl;
    strcpy(emp->officecode,"1");
    cout << "Manager ID: " << managerID << endl;
    emp->reportsTo = 1002;
    cout << "Job Title: ";
    cin >> emp->jobTitle;
}

void insertEmployee(Connection* conn, struct Employee emp)
{
    int find = findEmployee(conn, emp.employeeNumber, &emp);

    if (find == 1)
    {
        cout << "\nAn employee with the same employee number exists." << endl;
    }
    else
    {
        Statement* stmt = conn->createStatement();

        stmt->setSQL("INSERT INTO employees VALUES(:1,:2,:3,:4,:5,:6,:7,:8)");
        stmt->setInt(1, emp.employeeNumber);
        stmt->setString(2, emp.lastName);
        stmt->setString(3, emp.firstName);
        stmt->setString(4, emp.extension);
        stmt->setString(5, emp.email);
        stmt->setString(6, emp.officecode);
        stmt->setInt(7, emp.reportsTo);
        stmt->setString(8, emp.jobTitle);
        stmt->executeUpdate();
        conn->commit();
        conn->terminateStatement(stmt);
        cout << "\nThe new employee is added successfully." << endl;
    }
}