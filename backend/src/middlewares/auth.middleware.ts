import { db } from "../db";
import { eq } from "drizzle-orm";
import { users, type User } from "../db/schemas";
import type { Request, Response, NextFunction } from "express";
import { verifyJwtToken } from "../utils";

export interface AuthRequest extends Request {
  token?: string;
  user?: User;
}

export const protectedMiddleware = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction,
) => {
  try {
    const token = req.header("x-auth-token");

    if (!token) {
      return res.status(401).json({ message: "No auth token, access denied!" });
    }

    const decoded = verifyJwtToken(token);

    if (!decoded) {
      return res.status(401).json({ message: "Invalid token, access denied!" });
    }

    const [user] = await db
      .select()
      .from(users)
      .where(eq(users.id, decoded.userId));

    if (!user) {
      return res
        .status(401)
        .json({ message: "User not found, access denied!" });
    }

    req.user = user;
    req.token = token;

    next();
  } catch (error) {
    console.error("Error during authentication:", error);
    return res.status(500).json({ error, message: "Internal server error" });
  }
};
