import React, { useState, ChangeEvent, FormEvent } from "react";

const Publicaciones: React.FC = () => {
  const [titulo, setTitulo] = useState("");
  const [descripcion, setDescripcion] = useState("");
  const [precio, setPrecio] = useState("");
  const [stock, setStock] = useState(0);
  const [image, setImage] = useState<File | null>(null);

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const formData = new FormData();
    formData.append("name", titulo);
    formData.append("description", descripcion);
    formData.append("price", precio);
    formData.append("stock", stock.toString());
    if (image) {
      formData.append("image", image);
    }
    formData.append("id_user", "1"); // Cambia esto si luego quieres usar user_id dinámico

    try {
      const response = await fetch("http://127.0.0.1:8000/api/products", {
        method: "POST",
        body: formData,
      });

      if (!response.ok) {
        console.error("Error al subir el producto");
      }
    } catch (error) {
      console.error("Error en la solicitud:", error);
    }

    // Limpiar campos después de enviar
    setTitulo("");
    setDescripcion("");
    setPrecio("");
    setStock(0);
    setImage(null);
  };

  const handleImageChange = (e: ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setImage(file);
    }
  };

  return (
    <div className="container">
      <div className="form-container">
        <div className="form-card">
          <h2 className="h2_text">Subir Nueva Publicación</h2>
          <form onSubmit={handleSubmit}>
            <label>
              Título:
              <input type="text" value={titulo} onChange={(e) => setTitulo(e.target.value)} required />
            </label>
            <label>
              Descripción:
              <textarea value={descripcion} onChange={(e) => setDescripcion(e.target.value)} required />
            </label>
            <label>
              Stock:
              <input type="number" value={stock} onChange={(e) => setStock(Number(e.target.value))} required />
            </label>
            <label>
              Precio:
              <input type="text" value={precio} onChange={(e) => setPrecio(e.target.value)} required />
            </label>
            <label>
              Imagen:
              <input type="file" accept="image/*" onChange={handleImageChange} />
            </label>
            <button type="submit" className="btn-submit">Subir Publicación</button>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Publicaciones;
