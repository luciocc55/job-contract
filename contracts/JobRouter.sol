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