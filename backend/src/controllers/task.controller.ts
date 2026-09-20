import { db } from "../db";
import { tasks, type NewTask } from "../db/schemas";
import type { Response } from "express";
import type { AuthRequest } from "../middlewares/auth.middleware";
import { and, eq } from "drizzle-orm";

type TaskBody = Pick<NewTask, "title" | "description" | "hexColor"> & {
  dueDate?: string | null;
};
type TaskUpdates = Partial<
  Pick<NewTask, "title" | "description" | "hexColor" | "dueDate">
>;

function parseDueDate(value: string | null | undefined): Date | null | undefined {
  if (value === undefined || value === null) {
    return value;
  }

  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? undefined : date;
}

export async function addTask(
  req: AuthRequest<TaskBody>,
  res: Response,
) {
  try {
    const { title, description, hexColor, dueDate } = req.body;
    if (!title || !description || !hexColor) {
      return res.status(400).json({ message: "Missing required fields" });
    }

    const parsedDueDate = parseDueDate(dueDate);
    if (dueDate && parsedDueDate === undefined) {
      return res.status(400).json({ message: "Invalid due date" });
    }

    const newTask: NewTask = {
      title,
      description,
      hexColor,
      uid: req.user!.id,
      ...(parsedDueDate !== undefined ? { dueDate: parsedDueDate } : {}),
    };

    const [task] = await db.insert(tasks).values(newTask).returning();

    res.status(201).json({ message: "Task added successfully", ...task });
  } catch (error) {
    console.error("Error during task addition:", error);
    res.status(500).json({ error, message: "Internal server error" });
  }
}

export async function getTasks(req: AuthRequest, res: Response) {
  try {
    const userId = req.user!.id;
    const userTasks = await db
      .select()
      .from(tasks)
      .where(eq(tasks.uid, userId));
    res.status(200).json({ tasks: userTasks });
  } catch (error) {
    console.error("Error fetching tasks:", error);
    res.status(500).json({ error, message: "Internal server error" });
  }
}

export async function deleteTask(req: AuthRequest, res: Response) {
  try {
    const taskId = req.params.id;
    const userId = req.user!.id;

    await db
      .delete(tasks)
      .where(and(eq(tasks.id, taskId), eq(tasks.uid, userId)));

    res.status(200).json({ message: "Task deleted successfully" });
  } catch (error) {
    console.error("Error deleting task:", error);
    res.status(500).json({ error, message: "Internal server error" });
  }
}

export async function updateTask(
  req: AuthRequest<TaskBody>,
  res: Response,
) {
  try {
    const taskId = req.params.id;
    const userId = req.user!.id;
    const { title, description, hexColor, dueDate } = req.body;

    const updates: TaskUpdates = {
      title,
      description,
      hexColor,
      dueDate: parseDueDate(dueDate),
    };

    await db
      .update(tasks)
      .set({ ...updates, updatedAt: new Date() })
      .where(and(eq(tasks.id, taskId), eq(tasks.uid, userId)));

    res.status(200).json({ message: "Task updated successfully" });
  } catch (error) {
    console.error("Error updating task:", error);
    res.status(500).json({ error, message: "Internal server error" });
  }
}
