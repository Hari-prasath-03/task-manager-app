import { db } from "../db";

type AvailableTables = "users" | "tasks";

export async function truncateTable(tableName: AvailableTables): Promise<void> {
  const query = `TRUNCATE TABLE ${tableName} RESTART IDENTITY CASCADE;`;
  await db.execute(query);
}


