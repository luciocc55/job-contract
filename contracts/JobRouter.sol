pragma solidity 0.6.12;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./Job.sol";


contract JobsContract is Ownable {
    using SafeMath for uint256;
    mapping(uint256 => JobContract) jobs;
    uint256 jobsCount;

    function proposeJob(string memory _title, string memory _description ) external onlyOwner {
        JobContract job = new JobContract(_title, _description);
        jobs[jobsCount] = job;
        jobsCount++;
    }

    function editJob( 
        uint256 index,
        string memory _title,
        string memory _description,
        address _selectedApplicant,
        uint256 _jobStatus
    ) external onlyOwner {
        jobs[index].editJob(
            _title,
            _description,
            _selectedApplicant,
            _jobStatus
        );
    }

    function applyJob(
        uint256 index,
        string memory _experienceDescription,
        string memory _contact, 
        string memory _rate 
    ) external {
        jobs[index].applyJob(
            _experienceDescription,
            _contact,
            _rate
        );
    }

    function chooseApplicant(
        uint256 index,
        address _applicantAddress 
    ) external onlyOwner {
        jobs[index].chooseApplicant(
            _applicantAddress
        );
    }

    function destroyJob(
        uint256 index
    ) external onlyOwner {
        jobs[index].destroyJob();
    }

    function getApplicant(uint256 index, uint256 applicantIndex) external view returns(
        address addr,
        string memory experienceDescription,
        string memory contact,
        string memory rate
        ) { 
        return jobs[index].getApplicant(applicantIndex);
    }

    function getApplicantCount(uint256 index) external view returns(uint256) { 
        return jobs[index].getApplicantCount();
    }
    
    function getJob(uint256 index) external view returns(
        string memory description,
        string memory title,
        uint256 creationTimestamp,
        uint256 jobStatus,
        address selectedApplicant,
        uint256 applicantCount 
    ) { 
        return jobs[index].getJob();
    }

    function getJobsCount() external view returns(uint256) { 
        return jobsCount;
    }

}