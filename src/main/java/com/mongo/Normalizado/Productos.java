package com.mongo.Normalizado;

import com.mongodb.client.*;
import static com.mongodb.client.model.Filters.*;
import java.util.Arrays;
import org.bson.Document;

/**
 *
 * @author jeron
 */
public class Productos {
    
     

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase database = mongoClient.getDatabase("parcial3");
        MongoCollection<Document> collection = database.getCollection("productos");
        System.out.println("CONEXION EXITOSA");
        
        
        CrudProductos crudProductos = new CrudProductos();
        
     
      // Crear producto
        crudProductos.crearProducto("producto001", "Camiseta de algodon", "Camiseta 100% algodon, disponible en varios colores", 15.99, 200);
        // Leer producto
        crudProductos.leerProducto("producto001");     
        // Listar productos
        crudProductos.listarProductos();
        // Actualizar producto
        crudProductos.actualizarProducto("producto001", 20.22);
        // Eliminar producto
        crudProductos.eliminarProducto("producto001");
        
     
        //Obtener los productos con un precio mayor a 20 dolares
        FindIterable<Document> productos = collection.find((gt("precio", 20)));
        for (Document producto : productos) {
            System.out.println(producto.toJson());
    }

        
        
        
       
    }
}

        
        
        
        
        



        