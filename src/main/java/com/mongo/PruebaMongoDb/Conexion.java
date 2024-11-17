package com.mongo.PruebaMongoDb;

import com.mongodb.client.*;
import static com.mongodb.client.model.Filters.*;
import java.util.Arrays;
import org.bson.Document;

/**
 *
 * @author jeron
 */
public class Conexion {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase database = mongoClient.getDatabase("pruebas");
        MongoCollection<Document> collection = database.getCollection("tienda");
        System.out.println("CONEXION EXITOSA");
        
        
        // INICIO INSERTAR 10 REGISTROS
        Document producto1 = new Document("ProductoID", 1)
    .append("Nombre", "Camiseta")
    .append("Descripcion", "Camiseta de algodon")
    .append("Precio", 20)
    .append("Categoria", new Document("CategoriaID", 1).append("NombreCategoria", "Ropa"))
    .append("Comentarios", Arrays.asList(
        new Document("ComentarioID", 1).append("Texto", "Muy comoda").append("Cliente", "Juan"),
        new Document("ComentarioID", 2).append("Texto", "Buena calidad").append("Cliente", "Maria")
    ));

Document producto2 = new Document("ProductoID", 2)
    .append("Nombre", "Pantalon")
    .append("Descripcion", "Pantalon de mezclilla")
    .append("Precio", 40)
    .append("Categoria", new Document("CategoriaID", 1).append("NombreCategoria", "Ropa"))
    .append("Comentarios", Arrays.asList(
        new Document("ComentarioID", 3).append("Texto", "Excelente diseño").append("Cliente", "Luis"),
        new Document("ComentarioID", 4).append("Texto", "Comodo y duradero").append("Cliente", "Sofia")
    ));

Document producto3 = new Document("ProductoID", 3)
    .append("Nombre", "Zapatos")
    .append("Descripcion", "Zapatos deportivos")
    .append("Precio", 60)
    .append("Categoria", new Document("CategoriaID", 2).append("NombreCategoria", "Calzado"))
    .append("Comentarios", Arrays.asList(
        new Document("ComentarioID", 5).append("Texto", "Perfectos para correr").append("Cliente", "Carlos"),
        new Document("ComentarioID", 6).append("Texto", "Gran calidad").append("Cliente", "Laura")
    ));

Document producto4 = new Document("ProductoID", 4)
    .append("Nombre", "Gorra")
    .append("Descripcion", "Gorra de tela")
    .append("Precio", 15)
    .append("Categoria", new Document("CategoriaID", 1).append("NombreCategoria", "Ropa"))
    .append("Comentarios", Arrays.asList(
        new Document("ComentarioID", 7).append("Texto", "Muy estilizada").append("Cliente", "Pedro"),
        new Document("ComentarioID", 8).append("Texto", "Ligera y fresca").append("Cliente", "Ana")
    ));

Document producto5 = new Document("ProductoID", 5)
    .append("Nombre", "Cinturon")
    .append("Descripcion", "Cinturon de cuero")
    .append("Precio", 25)
    .append("Categoria", new Document("CategoriaID", 3).append("NombreCategoria", "Accesorios"))
    .append("Comentarios", Arrays.asList(
        new Document("ComentarioID", 9).append("Texto", "Buena calidad").append("Cliente", "Ricardo"),
        new Document("ComentarioID", 10).append("Texto", "Se ajusta perfectamente").append("Cliente", "Maria")
    ));

Document producto6 = new Document("ProductoID", 6)
    .append("Nombre", "Bolso")
    .append("Descripcion", "Bolso de mano")
    .append("Precio", 50)
    .append("Categoria", new Document("CategoriaID", 3).append("NombreCategoria", "Accesorios"))
    .append("Comentarios", Arrays.asList(
        new Document("ComentarioID", 11).append("Texto", "Bonito diseño").append("Cliente", "Isabel"),
        new Document("ComentarioID", 12).append("Texto", "Espacioso y práctico").append("Cliente", "Diana")
    ));

Document producto7 = new Document("ProductoID", 7)
    .append("Nombre", "Sudadera")
    .append("Descripcion", "Sudadera con capucha")
    .append("Precio", 30)
    .append("Categoria", new Document("CategoriaID", 1).append("NombreCategoria", "Ropa"))
    .append("Comentarios", Arrays.asList(
        new Document("ComentarioID", 13).append("Texto", "Muy cómoda").append("Cliente", "Rosa"),
        new Document("ComentarioID", 14).append("Texto", "Calienta bastante").append("Cliente", "Javier")
    ));

Document producto8 = new Document("ProductoID", 8)
    .append("Nombre", "Bufanda")
    .append("Descripcion", "Bufanda de lana")
    .append("Precio", 20)
    .append("Categoria", new Document("CategoriaID", 3).append("NombreCategoria", "Accesorios"))
    .append("Comentarios", Arrays.asList(
        new Document("ComentarioID", 15).append("Texto", "Caliente y suave").append("Cliente", "Manuela"),
        new Document("ComentarioID", 16).append("Texto", "Bonita textura").append("Cliente", "Pablo")
    ));

Document producto9 = new Document("ProductoID", 9)
    .append("Nombre", "Reloj")
    .append("Descripcion", "Reloj de pulsera")
    .append("Precio", 100)
    .append("Categoria", new Document("CategoriaID", 3).append("NombreCategoria", "Accesorios"))
    .append("Comentarios", Arrays.asList(
        new Document("ComentarioID", 17).append("Texto", "Moderno y elegante").append("Cliente", "Raul"),
        new Document("ComentarioID", 18).append("Texto", "Gran calidad").append("Cliente", "Andrea")
    ));

Document producto10 = new Document("ProductoID", 10)
    .append("Nombre", "Sombrero")
    .append("Descripcion", "Sombrero de paja")
    .append("Precio", 35)
    .append("Categoria", new Document("CategoriaID", 3).append("NombreCategoria", "Accesorios"))
    .append("Comentarios", Arrays.asList(
        new Document("ComentarioID", 19).append("Texto", "Ideal para el verano").append("Cliente", "Gloria"),
        new Document("ComentarioID", 20).append("Texto", "Ligero y cómodo").append("Cliente", "Diego")
    ));

collection.insertMany(Arrays.asList(producto1, producto2, producto3, producto4, producto5, producto6, producto7, producto8, producto9, producto10));
  //FIN INSERTAR 10 REGISTROS
    
  //INICIO ACTUALIZAR 5 REGISTROS
  collection.updateOne(eq("ProductoID", 1), new Document("$set", new Document("Precio", 25)));
collection.updateOne(eq("ProductoID", 2), new Document("$set", new Document("Descripcion", "Pantalon ajustado de mezclilla")));
collection.updateOne(eq("ProductoID", 3), new Document("$set", new Document("Nombre", "Zapatos deportivos premium")));
collection.updateOne(eq("ProductoID", 4), new Document("$set", new Document("Categoria.NombreCategoria", "Accesorios de Ropa")));
collection.updateOne(eq("ProductoID", 5), new Document("$set", new Document("Comentarios", Arrays.asList(
    new Document("ComentarioID", 21).append("Texto", "Diseño elegante").append("Cliente", "Fernando"),
    new Document("ComentarioID", 22).append("Texto", "Perfecto para trajes").append("Cliente", "Lucia")
))));
    //FIN ACTUALIZAR 5 REGISTROS

    //INICIO ELIMINAR 2 REGISTROS 
    collection.deleteOne(eq("ProductoID", 9));
    collection.deleteOne(eq("ProductoID", 10));
    //FIN ELIMINAR 2 REGISTROS
    
    //INICIO CONSULTAR LOS PRODUCTOS MAYORES A 10 DOLARES
    FindIterable<Document> productos = collection.find(gt("Precio", 10));
    for (Document producto : productos) {
        System.out.println(producto.toJson());
        System.out.println("\n");
    }
    //FIN CONSULTAR LOS PRODUCTOS MAYORES A 10 DOLARES
    
    //INICIO CONSULTAR LOS PRODUCTOS MAYORES A 50 DOLARES Y QUE SU CATEGORIA SEA ROPA
    FindIterable<Document> productos2 = collection.find(and(gt("Precio", 50), eq("Categoria.NombreCategoria", "Ropa")));
    for (Document producto : productos2) {
        System.out.println(producto.toJson());
    }
    //FIN CONSULTAR LOS PRODUCTOS MAYORES A 50 DOLARES Y QUE SU CATEGORIA SEA ROPA
    
    }
} 

