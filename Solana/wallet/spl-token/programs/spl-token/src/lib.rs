use anchor_lang::prelude::*;

declare_id!("BjrkHCqnZPhw7EfukxRFbKU4Q8P8WJ9DrGFoEzN3VmnD");

#[program]
pub mod spl_token {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
