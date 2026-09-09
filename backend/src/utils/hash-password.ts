import { hash, compare } from "bcryptjs";

async function hashPassword(password: string): Promise<string> {
  const hashedPassword = await hash(password, 8);
  return hashedPassword;
}

async function verifyPassword(password: string, hashedPassword: string): Promise<boolean> {
  const isMatch = await compare(password, hashedPassword);
  return isMatch;
}

export { hashPassword, verifyPassword };