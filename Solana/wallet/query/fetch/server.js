import fetch from 'node-fetch';

const API_KEY = "lP7ZcAEqMRVqVAPDXhCi7PleSHCKIdJo";
const QUERY_ID = 4663427;

async function fetchDuneData() {
  // Step 1: Run the query
  const execRes = await fetch(`https://api.dune.com/api/v1/query/${QUERY_ID}/execute`, {
    method: "POST",
    headers: {
      "X-Dune-API-Key": API_KEY
    }
  });
  const execData = await execRes.json();
  const executionId = execData.execution_id;

  // Step 2: Wait a bit for query to finish, or poll status (simplified here)
  await new Promise(r => setTimeout(r, 10000)); // 10 sec delay

  // Step 3: Get results
  const resultRes = await fetch(`https://api.dune.com/api/v1/execution/${executionId}/results`, {
    headers: {
      "X-Dune-API-Key": API_KEY
    }
  });
  const resultData = await resultRes.json();
  console.log(resultData);
}

fetchDuneData();
