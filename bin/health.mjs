const maxAttempts = 24
let attempts = 0

async function maybeRetryCheckHealth(url) {
  attempts += 1
  if (attempts !== maxAttempts) {
    await new Promise((resolve) => setTimeout(resolve, 5000))
    return await checkHealth(url)
  } else {
    return false
  }
}

async function checkHealth(url) {
  try {
    const response = await (await fetch(`${url}/health`)).json()
    if (!response.healthy) {
      return await maybeRetryCheckHealth(url)
    }
    return true
  } catch (error) {
    console.error(error)
    return await maybeRetryCheckHealth(url)
  }
}

let argUrl = 'http://localhost:3333'
if (process.argv.length === 3) {
  argUrl = process.argv[2]
}

checkHealth(argUrl)
  .then((healthy) => {
    console.log(`Server ${healthy ? 'is' : 'is not'} healthy`)
    process.exit(!healthy)
  })
  .catch((error) => {
    console.error(`Server is not healthy: ${error.message}`)
    process.exit(1)
  })
