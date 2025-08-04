const app = require('./app');
const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Backend WhatsApp bot corriendo en http://0.0.0.0:${PORT}`);
  console.log(`📘 Swagger UI: http://0.0.0.0:${PORT}/api-docs`);
  console.log(`🌐 Acceso externo: https://backend-botwhatsapp.fly.dev/:${PORT}/api-docs`);
});
