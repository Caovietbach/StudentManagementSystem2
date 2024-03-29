
# Student Information Management System

## Requiremnts

Since this app is written as a Spring Boot Java application, we need to follow some requirements to write/run the app:

### Java Development Kit (JDK):

We must have JDK (Java Development Kit) installed on your system as the JDK includes the Java compiler (javac) and the Java runtime environment (java) which provide necessary tools to create/run Java apps.

### Text Editor or Integrated Development Environment (IDE):

We should have a text editor or an Integrated Development Environment (IDE) installed to write and edit the Java code. Common choices include Visual Studio Code, IntelliJ IDEA, Eclipse, or Notepad++.

### Having Command Prompt (CMD) or Terminal:

In some cases, when we don't have access to text editor apps or an IDE, we will need access to a command-line interface such as Command Prompt (on Windows) or Terminal (on macOS or Linux) as a replacement.

### Knowledge of Basic Command-Line Operations:

You should be familiar with basic command-line operations such as navigating directories (cd command), compiling Java files (javac command), and running Java applications (java command).

### Spring Boot dependencies:

Spring Boot framework gives us a lot of tools to create a Java Web App and based from your preferences, you can choose dependencies that you can work best with but in this project, we will use Web Sping, MySQL Driver, Thymeleaf, Spring Data JPA dependencies to write the application. You can generate a new Spring Boot project using Spring Initializr. Go to Google and search start.spring.io, and select Maven or Gradle, add those dependencies (Web, MySQL Driver, Thymeleaf, Spring Data JPA), and click on "Generate" to download the project zip file. Once downloaded successfully, extract it and open it by your preference IDE tool or Text Editor app.

### Read the Spring Boot Documentation:

Since we are using Spring Boot Framework to create this app, it is essential to read the documentation given by the Framework's developers to understand the stucture of it and its unique syntaxes. It is advised by the writer to create some small projects to further understand some features of the Framework before applying it to this project.


## Planning

Let's plan the structure of the application by identifying the classes and their responsibilities. The app will have four main components: Entity, Service, Controller, and Repositories, each represented by corresponding packages with a Java class or interface. 
The Student class in the Entity package maps individual student objects to database tables. The StudentService in the Service package handles business logic and acts as a bridge between controllers and repositories. The StudentRepository in the Repositories package provides data access interfaces. The StudentController in the Controller package manages HTTP requests, executes business logic, and returns responses.

Next, we will create three HTML files (index.html, addStudent.html, editStudent.html) in src/main/resources/templates to design the app's interface. After that, we will set up the database, Thymeleaf configuration, and Server Configuration in the application.properties file in the same folder.

After that, you can comply and run the app via your IDE tool or run it via command prompt or console command. You should be able to access your application at your configured server. 

## Developing

### Set up database

Open a terminal (command prompt in Microsoft Windows) and open a MySQL client as a user who can create new users.

For example, on a Linux system, use the following command:
``` 
$ sudo mysql --password
``` 
To create a new database, run the following commands at the mysql prompt:

``` 
mysql> create database db_example;  (Creates the new database)
mysql> create user 'springuser'@'%' identified by 'ThePassword'; (Creates the user)
mysql> grant all on db_example.* to 'springuser'@'%'; (Gives all privileges to the new user on the newly created database)
``` 

### Student 

In the Student class, we will define attributes such as id, name, and email along with methods to add and display student information. These methods encapsulate the behavior related to student objects.

``` 
package org.example.studentmanagementsystem2.entity;


import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Entity
public class Student {

    @Id
    @GeneratedValue
    private long id;

    private String name;

    private String email;

    // Default constructor
    public Student(){

    }

    // Parameterized constructor
    public Student(String name, String email){
        this.name = name;
        this.email = email;
    }

    // Getter method for id
    public long getId(){
        return id;
    }

    // Setter method for id
    public void setId(long id){
        this.id = id;
    }

    // Getter method for name
    public String getName(){
        return name;
    }

    // Setter method for name
    public void setName(String name){
        this.name = name;
    }

    // Getter method for email
    public String getEmail(){
        return email;
    }

    // Setter method for email
    public void setEmail(String email){
        this.email = email;
    }
}

``` 

### StudentRepository

The StudentRepository interface serves as a contract for accessing and managing Student entities within the application. It extends the Spring Data CrudRepository interface, inheriting basic CRUD (Create, Read, Update, Delete) operations for the Student entity. The primary responsibility of the existsByEmail method is to provide a convenient way to determine whether a student with a particular email exists in the database. This method encapsulates the logic required to execute a query to check for the existence of a student with the specified email.

``` 
package org.example.studentmanagementsystem2.repository;

import org.example.studentmanagementsystem2.entity.Student;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

// Annotation indicating that this interface serves as a repository
@Repository
public interface StudentRepository extends CrudRepository<Student, Long> {
    // Declaration of a query method to check if a student with a specific email exists
    // Spring Data JPA will automatically implement this method based on the method name
    boolean existsByEmail(String email);
}

``` 

### StudentService
The code provided is a service class named StudentService that manages student-related operations. It is annotated with @Service in the Spring framework, indicating it is a service component. The @Transactional annotation ensures transactional context for each method. StudentService injects an instance of StudentRepository using @Autowired for database operations. It provides methods for CRUD operations on student entities: listAll(), save(), get(), and delete(). Two validation methods, validateNewInformation() and validateEditInformation(), check for empty fields and duplicate emails. These methods return error messages for validation errors.

``` 
package org.example.studentmanagementsystem2.service;

import jakarta.transaction.Transactional;
import org.example.studentmanagementsystem2.entity.Student;
import org.example.studentmanagementsystem2.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Transactional
public class StudentService {
    @Autowired
    private StudentRepository repo;

    // Method to list all students
    public List<Student> listAll() {
        return (List<Student>) repo.findAll();
    }

    // Method to save a student
    public void save(Student student) {
        repo.save(student);
    }

    // Method to get a student by id
    public Student get(long id) {
        return repo.findById(id).get();
    }

    // Method to delete a student by id
    public void delete(long id) {
        repo.deleteById(id);
    }

    // Method to validate new student information
    public String validateNewInformation(Student student){
        String err = null;
        // Checking if student name is empty
        if(student.getName() == ""){
            err = "Student must have a name";
            System.out.println("1");
        }
        // Checking if student email is empty
        if(student.getEmail() == ""){
            err = "Student must have an email address";
            System.out.println("2");
        }
        // Checking if student email already exists in the database
        String email = student.getEmail();
        boolean emailDuplicate = repo.existsByEmail(email);
        if (emailDuplicate == true){
            err = "This email address has been used";
            System.out.println("3");
        }
        return err;
    }

    // Method to validate edited student information
    public String validateEditInformation(Student student){
        String err = null;
        // Checking if student name is empty
        if(student.getName() == ""){
            err = "Student must have a name";
            System.out.println("1");
        }
        // Checking if student email is empty
        if(student.getEmail() == ""){
            err = "Student must have an email address";
            System.out.println("2");
        }
        return err;
    }
}
``` 
### StudentController
The StudentController class in the MVC architecture handles HTTP requests for student management. It depends on StudentService for student operations. The @Controller annotation marks it as a Spring MVC controller. The mappings are:
- @RequestMapping("/") maps the root URL to viewHomePage()
- @RequestMapping("/addStudent") maps "/addStudent" to showNewStudentPage()
- @RequestMapping(value = "/save", method = RequestMethod.POST) maps POST requests to saveStudent()
- @RequestMapping(value = "/saveEdit", method = RequestMethod.POST) maps POST requests to saveEditStudent()
- @RequestMapping("/edit/{id}") maps "/edit/{id}" to showEditStudentPage()
- @RequestMapping("/delete/{id}") maps "/delete/{id}" to deleteStudent()

```
package org.example.studentmanagementsystem2.controller;


import org.example.studentmanagementsystem2.entity.Student;
import org.example.studentmanagementsystem2.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
@Controller
public class StudentController {

    private final StudentService service;

    @Autowired
    public StudentController(StudentService service) {
        this.service = service;
    }

    // Request mapping for the home page
    @RequestMapping("/")
    public String viewHomePage(Model model) {
        // Retrieves list of all students
        List<Student> listStudents = service.listAll();
        model.addAttribute("listStudents", listStudents);

        return "index"; // Return the name of the template to render (assuming index.html is in src/main/resources/templates)
    }

    // Request mapping to show the page for adding a new student
    @RequestMapping("/addStudent")
    public String showNewStudentPage(Model model) {
        // Create a new student object and add it to the model
        Student student = new Student();
        model.addAttribute("student", student);

        return "addStudent"; // Return the name of the template to render
    }

    // Request mapping to save a new student
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String saveStudent(@ModelAttribute("student") Student student, Model model) {
        // Validate new student information
        String errorMessage = service.validateNewInformation(student);
        if (errorMessage != null) {
            // If validation fails, add error message to the model and return to the add student page
            model.addAttribute("errorMessage", errorMessage);
            return "addStudent";
        } else {
            // If validation passes, save the student and redirect to the home page
            service.save(student);
            return "redirect:/";
        }
    }

    // Request mapping to save edited student information
    @RequestMapping(value = "/saveEdit", method = RequestMethod.POST)
    public String saveEditStudent(@ModelAttribute("student") Student student, RedirectAttributes model) {
        // Validate edited student information
        String errorMessage = service.validateEditInformation(student);
        if (errorMessage != null) {
            // If validation fails, add error message as a flash attribute and redirect to the edit student page
            model.addFlashAttribute("errorMessage", errorMessage);
            long id = student.getId();
            return "redirect:/edit/" + id;
        } else {
            // If validation passes, save the edited student and redirect to the home page
            service.save(student);
            return "redirect:/";
        }
    }

    // Request mapping to show the edit student page
    @RequestMapping("/edit/{id}")
    public ModelAndView showEditStudentPage(@PathVariable(name = "id") long id) {
        ModelAndView mav = new ModelAndView("editStudent"); // Corrected template name
        // Retrieve the student with the given id
        Student student = service.get(id);
        mav.addObject("student", student);

        return mav;
    }

    // Request mapping to delete a student
    @RequestMapping("/delete/{id}")
    public String deleteStudent(@PathVariable(name = "id") long id) {
        // Delete the student with the given id
        service.delete(id);
        return "redirect:/"; // Redirect to the home page after deletion
    }
}
 ``` 
### application.properties

This file contains the configuration of the app's database, Thymeleaf configuration, and Server Configuration

``` 
# Database Configuration



# Thymeleaf Configuration
spring.thymeleaf.prefix=classpath:/templates/  # Prefix for Thymeleaf templates
spring.thymeleaf.suffix=.html  # Suffix for Thymeleaf templates
spring.thymeleaf.cache=false  # Disable template caching for development

# Server Configuration
server.port=8080  # Port number for running the Spring Boot application

``` 

### StudentmanagementApplication
This file contain the sole function to run the app.

``` 
package org.example.studentmanagementsystem2;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class StudentManagementSystem2 {

	public static void main(String[] args) {
		SpringApplication.run(StudentmanagementApplication.class, args);
	}

}


``` 
### index.html

``` 
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:th="http://thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Index</title>
</head>
<body>
<div align="center">
    <h1>List of Students</h1>
    <a href="addStudent">Add new student information</a>
    <br/><br/>
    <table border="1" cellpadding="10">
        <thead>
        <tr>
            <th>Student ID</th>
            <th>Name</th>
            <th>Student Email</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <tr th:each="student: ${listStudents}">
            <td th:text="${student.id}">Student ID</td>
            <td th:text="${student.name}">Name</td>
            <td th:text="${student.email}">Student Email</td>
            <td>
                <a th:href="@{'/edit/' + ${student.id}}">Edit</a>
                &nbsp;&nbsp;&nbsp;
                <a th:href="@{'/delete/' + ${student.id}}">Delete</a>
            </td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>
``` 

### addStudent.html

``` 
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:th="http://thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Add New Student Information</title>

</head>
<body>
<div align="center">
    <h1>Add new student</h1>
    <br />
    <form action="#" th:action="@{/save}" th:object="${student}"
          method="post">


        <table border="0" cellpadding="10">
            <tr>
                <td>Student Name:</td>
                <td><input type="text" th:field="*{name}" /></td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><input type="text" th:field="*{email}" /></td>
            </tr>
            <tr>
                <td colspan="2"><button type="submit">Save</button> </td>
            </tr>
        </table>
    </form>
    <p th:if="${errorMessage}" th:text="${errorMessage}" style="color: red;"></p>
</div>
</body>
</html>
``` 

### editStudent.html

``` 
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:th="http://thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Edit Student Information</title>
</head>
<body>
<div align="center">
    <h1>Edit Student</h1>
    <br />
    <form action="#" th:action="@{/saveEdit}" th:object="${student}"
          method="post">

        <table border="0" cellpadding="10">
            <tr>
                <td>Student ID:</td>
                <td>
                    <input type="text" th:field="*{id}" readonly="readonly" />
                </td>
            </tr>
            <tr>
                <td>Student Name:</td>
                <td>
                    <input type="text" th:field="*{name}" />
                </td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><input type="text" th:field="*{email}" /></td>
            </tr>
            <tr>
                <td colspan="2"><button type="submit">Save</button> </td>
            </tr>
        </table>
    </form>
    <p th:if="${errorMessage}" th:text="${errorMessage}" style="color: red;"></p>
</div>
</body>
</html>

``` 

## How to run the application

This is a quick summary of how to use the application:

### Launch the Application:

In order to run the application, we have 2 ways:

#### Compiling and running the App in your IDE tools. 

Find the button that allow user to Complie and Run the Main class of the application then click it.

#### Run through command Prompt or Terminal

- Open the Command Prompt or Terminal in your device.

- Navigate to the root directory of your Spring Boot project. This directory should contain the pom.xml file.

- Build the project using Maven:
``` 
 mvn clean package
``` 
- After the build is successful, navigate to the directory containing the compiled .jar file. Typically, it's located in the target directory inside your project directory.

- Run the application using the following command:

``` 
java -jar your-application-name.jar (Replace your-application-name.jar with the actual name of your .jar file)
``` 

### Accessing the website

After successfully compile and run the app, you now enter in you prefer browser end this line: 

``` 
http://localhost:8080
``` 


### Viewing All Student Information:

After successfully run the app and access the website, you can see all the saved student information in the screen.

### Adding a Student:

If click the "Add new student information":
You'll be presented a form including the needed information for a new student (name and email, the id is auto generated). You need to enter the student's name and student's email.
If the input value of those fields are null, you will be asked to write them.
If the email you entered already used, you'll be prompted to enter a different ID.
Once all students are added, you'll go back to the index and see the new student at the end of the list.

### Editing Student Information:

If click the "Edit" button in the Action column, the website will send you to the editStudent screne:
You can see the value of the student you choose. In here, you can change the name or email of the student whose information you want to edit. However, if you try to leave the email or name input vacant then saving, a warning will be sent. It alert user that the name and email of a student cannot be null. If the information is valid, the application will send you back to the index and you can see the new information appear in the table.

### Deleting Student Information:

If click the "Delete" button in the Actions column, the application will delete the student's information from the student information list.


### Exiting the Application:

You can shut down the app by closing the browser tap. 

 

