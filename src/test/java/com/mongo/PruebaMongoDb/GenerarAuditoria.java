package com.mongo.PruebaMongoDb;
import java.sql.*;

public class GenerarAuditoria {

    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");
            CallableStatement ejecucion = conexion.prepareCall("CALL javaa.generar_auditoria(?, ?)");

            ejecucion.setDate(1, Date.valueOf("2024-01-01"));
            ejecucion.setDate(2, Date.valueOf("2024-12-31"));
            ejecucion.execute();
            ejecucion.close();

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace(); 
        }
    }
}
