import mongoose from 'mongoose'
import app from './express'
import config from '../config/config' 

mongoose
  .connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
  })
  .then(() => {
    console.log(`Connected to MongoDB at ${process.env.MONGODB_URI}`)
    app.listen(config.port, () => {
      console.log(`Express server listening on port ${config.port}`)
    })
  })
  .catch(err => {
    console.error('MongoDB connection error:', err)
    process.exit(1)
  })
