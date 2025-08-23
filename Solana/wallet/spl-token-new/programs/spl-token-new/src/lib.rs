use anchor_lang::prelude::*;

declare_id!("B1dHUmMpGngs2R5QubLDUw9W7kn89u9yw6ghTMvK2hbh");

#[program]
pub mod spl_token_new {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
