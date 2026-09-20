import { Router } from "express";
import { protectedMiddleware } from "../middlewares/auth.middleware";
import {
  addTask,
  deleteTask,
  getTasks,
  updateTask,
} from "../controllers/task.controller";

const taskRoutes: Router = Router();

taskRoutes.post("/", protectedMiddleware, addTask);
taskRoutes.get("/", protectedMiddleware, getTasks);
taskRoutes.delete("/:id", protectedMiddleware, deleteTask);
taskRoutes.put("/:id", protectedMiddleware, updateTask);

export default taskRoutes;
