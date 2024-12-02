package com.mongo.Normalizado;

import com.mongodb.client.*;
import static com.mongodb.client.model.Filters.*;
import org.bson.Document;

public class CrudProductos {

    String uri = "mongodb://localhost:27017";
    MongoClient mongoClient = MongoClients.create(uri);
    MongoDatabase database = mongoClient.getDatabase("parcial3");
    MongoCollection<Document> collection = database.getCollection("productos");

    public void crearProducto(String id, String nombre, String descripcion, double precio, int stock) {
        Document producto = new Document("_id", id)
                .append("nombre", nombre)
                .append("descripcion", descripcion)
                .append("precio", precio)
                .append("stock", stock);
        collection.insertOne(producto);
        System.out.println("Producto insertado exitosamente");
    }

    public void leerProducto(String id) {
        System.out.println("\n");
        Document producto = collection.find(eq("_id", id)).first();
        if (producto != null) {
            System.out.println("Producto encontrado: " + producto.toJson());
        } else {
            System.out.println("Producto no encontrado");
        }
    }

    public void actualizarProducto(String id, double precio) {
        collection.updateOne(eq("_id", id), new Document("$set", new Document("precio", precio)));
    }

    public void eliminarProducto(String id) {
        collection.deleteOne(eq("_id", id));
        System.out.println("Producto eliminado exitosamente");
    }

    public void listarProductos() {
        System.out.println("\n");
        FindIterable<Document> productos = collection.find();
        for (Document producto : productos) {
            System.out.println(producto.toJson());
        }
    }
}
