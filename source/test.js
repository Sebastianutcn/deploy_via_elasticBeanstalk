const { exec } = require('child_process');
const http = require('http');

const port = process.env.PORT || 8080;
const appCommand = 'node app.js';

// Start the Node.js application
const appProcess = exec(appCommand);

appProcess.stdout.on('data', (data) => {
  console.log(data);
  if (data.includes(`App is running on port ${port}`)) {
    // Application has started, make an HTTP request to check the response
    http.get(`http://localhost:${port}`, (res) => {
      let responseData = '';

      res.on('data', (chunk) => {
        responseData += chunk;
      });

      res.on('end', () => {
        if (responseData.includes('Hello World!')) {
          console.log('Test passed: "Hello World!" was returned.');
          appProcess.kill();  // Terminate the app process
          process.exit(0);
        } else {
          console.log('Test failed: "Hello World!" was not returned.');
          appProcess.kill();  // Terminate the app process
          process.exit(1);
        }
      });
    }).on('error', (err) => {
      console.error(`Test failed: Could not make request - ${err.message}`);
      appProcess.kill();  // Terminate the app process
      process.exit(1);
    });
  }
});

appProcess.stderr.on('data', (data) => {
  console.error(`Error: ${data}`);
  process.exit(1);
});

