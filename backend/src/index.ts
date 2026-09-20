import cors from "cors";
import express from "express";
import authRouter from "./routes/auth.route";
import taskRoutes from "./routes/task.route";

const PORT = 8000;

const app = express();
app.use(express.json());
app.use(
  cors({
    origin: true,
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "x-auth-token"],
  }),
);

app.use("/auth", authRouter);
app.use("/tasks", taskRoutes);

app.get("/", (req, res) => {
  res.send("Hello, World!");
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
