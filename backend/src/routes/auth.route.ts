import { Router } from "express";
import { getMe, login, signup } from "../controllers/auth.controller";
import { protectedMiddleware } from "../middlewares/auth.middleware";

const authRouter: Router = Router();

authRouter.post("/signup", signup);
authRouter.post("/login", login);
authRouter.get("/me", protectedMiddleware, getMe);

export default authRouter;
