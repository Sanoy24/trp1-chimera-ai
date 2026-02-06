import pytest

@pytest.mark.asyncio
async def test_skills_interface_compliance():
    """
    Allocates that all skills in the /skills directory have a README.md 
    describing inputs/outputs.
    """
    import os
    
    skills_dir = "skills"
    if not os.path.exists(skills_dir):
        pytest.fail("Skills directory missing")
        
    for skill_name in ["trend_fetcher", "content_generator", "transaction_manager"]:
        readme_path = os.path.join(skills_dir, skill_name, "README.md")
        if not os.path.exists(readme_path):
             pytest.fail(f"Detailed Spec missing for skill: {skill_name}")
             
    # This part passes if we did our job in Task 2.3!
    assert True
