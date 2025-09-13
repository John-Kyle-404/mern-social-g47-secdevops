import express from 'express'
import authCtrl from '../controllers/auth.controller'
import bcrypt  from 'bcrypt'
import jwt     from 'jsonwebtoken'
import User    from '../models/user.model'

const router = express.Router()

// SIGN IN
router.route('/auth/signin')
  .post(authCtrl.signin)

// SIGN OUT
router.route('/auth/signout')
  .get(authCtrl.signout)

// SIGN UP
router.route('/auth/signup')
  .post(async (req, res) => {
    try {
      const { name, email, password } = req.body
      if (!name || !email || !password) {
        return res.status(400).json({ message: 'All fields are required' })
      }
      const exists = await User.findOne({ email })
      if (exists) {
        return res.status(409).json({ message: 'Email already in use' })
      }
      const hash = await bcrypt.hash(password, 10)
      const user = await User.create({ name, email, password: hash })
      const token = jwt.sign(
        { id: user._id },
        process.env.JWT_SECRET || 'secret',
        { expiresIn: '1h' }
      )
      res.status(201).json({ token })
    } catch (err) {
      console.error(err)
      res.status(500).json({ message: 'Server error' })
    }
  })

export default router
