import { sign, verify } from "jsonwebtoken";

function generateJwtToken(userId: string, options?: {}): string {
  return sign({ userId, ...options }, process.env.JWT_SECRET!);
}

function verifyJwtToken(token: string): { userId: string } | null {
  const payload = verify(token, process.env.JWT_SECRET!);
  if (typeof payload === "object" && payload !== null && "userId" in payload) {
    return { userId: payload.userId as string };
  }
  return null;
}

export { generateJwtToken, verifyJwtToken };
