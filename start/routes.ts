/*
|--------------------------------------------------------------------------
| Routes
|--------------------------------------------------------------------------
|
| This file is dedicated for defining HTTP routes. A single file is enough
| for majority of projects, however you can define routes in different
| files and just make sure to import them inside this file. For example
|
| Define routes in following two files
| ├── start/routes/cart.ts
| ├── start/routes/customer.ts
|
| and then import them inside `start/routes.ts` as follows
|
| import './routes/cart'
| import './routes/customer'
|
*/

import Route from '@ioc:Adonis/Core/Route'
import * as child from 'child_process'

Route.get('/', async () => {
  return { hello: 'world' }
})

Route.get('/gamemode/:containerId/:gamemode/:username', async ({ params }) => {
  try {
    const result = await child.execSync(
      `docker exec ${params.containerId} rcon-cli gamemode ${params.gamemode} ${params.username}`
    )
    return { result: result.toString() }
  } catch (error: unknown) {
    if (error instanceof Error) {
      return { error: error.toString() }
    }
    return { error: 'Unknown error' }
  }
})
