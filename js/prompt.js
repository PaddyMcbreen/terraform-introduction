const prompt = require('prompt-sync')();

// Create public infrastructure:
const create1 = prompt("Would you like to create public subnets?: (yes/no)")

if (create1 === yes){
    const createPublic = prompt("How many public subnets would you like to create?: (enter a number)")

    if (createPublic === Number){
        console.log(`Creating complete infrastructure for ${createPublic} public subnets`)
        // public-subnet-count.default = createPublic

    } 
    else {
        console.log("Please enter a vaild number")
    }
}


// Create private infrastructure:
else if (create1 === no){
    const create2 = prompt("Would you like to create private subnets?: (yes/no)")

    if (create2 === yes){
        const createPrivate = prompt("How many private subnets would you like to create?: (enter a number)")

        if (createPrivate === Number){
            console.log(`Creating complete infrastructure for ${createPublic} public subnets`)
            // private-subnet-count.default = createPrivate

        } 
        else {
            console.log("Please enter a valid number")
        }
    } 
    else {
        console.log("No private subnets have been created")
    }
}

