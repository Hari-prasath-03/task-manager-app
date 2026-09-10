import { db } from "../db";
import { eq } from "drizzle-orm";
import { users, type NewUser } from "../db/schemas";
import type { Request, Response } from "express";
import { hashPassword, verifyPassword, generateJwtToken } from "../utils";
import type { AuthRequest } from "../middlewares/auth.middleware";

interface SignupBody {
  name: string;
  email: string;
  password: string;
}

interface LoginBody {
  email: string;
  password: string;
}

export async function signup(req: Request<{}, {}, SignupBody>, res: Response) {
  try {
    const { name, email, password } = req.body;
    if (!name || !email || !password) {
      return res
        .status(400)
        .json({ message: "Name, email, and password are required" });
    }

    // Check if a user with the same email already exists
    const existingUser = await db
      .select()
      .from(users)
      .where(eq(users.email, email));
    if (existingUser.length) {
      return res
        .status(400)
        .json({ message: "User with same email already exists" });
    }

    // Create a new user
    const hashedPassword = await hashPassword(password);
    const newUser: NewUser = {
      name,
      email,
      password: hashedPassword,
    };
    const [user] = await db.insert(users).values(newUser).returning();
    res.status(201).json({ ...user, message: "User created successfully" });
  } catch (error) {
    console.error("Error during signup:", error);
    res.status(500).json({ error, message: "Internal server error" });
  }
}

export async function login(req: Request<{}, {}, LoginBody>, res: Response) {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res
        .status(400)
        .json({ message: "Email and password are required" });
    }

    const [existingUser] = await db
      .select()
      .from(users)
      .where(eq(users.email, email));
    if (!existingUser) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    // Check if the provided password matches the stored hash
    const isMatch = await verifyPassword(password, existingUser.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    const token = generateJwtToken(existingUser.id);

    res
      .status(200)
      .json({ token, ...existingUser, message: "Login successful" });
  } catch (error) {
    console.error("Error during login:", error);
    res.status(500).json({ error, message: "Internal server error" });
  }
}

export async function getMe(req: AuthRequest, res: Response) {
  return res.status(200).json({ ...req.user, token: req.token, message: "User fetched successfully" });
}
