package com.example;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Calculator {

    public static void main(String[] args) {

        // Calculator values
        double num1 = 10;
        double num2 = 8;

        // Calculations
        double addition = num1 + num2;
        double subtraction = num1 - num2;
        double multiplication = num1 * num2;
        double division = num1 / num2;

        // Display results
        System.out.println("Addition: " + addition);
        System.out.println("Subtraction: " + subtraction);
        System.out.println("Multiplication: " + multiplication);
        System.out.println("Division: " + division);

        // SQL statement to save results
        String sql = """
                INSERT INTO calculator_results
                (addition, subtraction, multiplication, division)
                VALUES (?, ?, ?, ?)
                """;

        // Save results to MySQL
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDouble(1, addition);
            statement.setDouble(2, subtraction);
            statement.setDouble(3, multiplication);
            statement.setDouble(4, division);

            statement.executeUpdate();

            System.out.println("Calculator results saved to database!");

        } catch (SQLException e) {

            System.out.println("Failed to save calculator results to database.");
            e.printStackTrace();
        }
    }
}