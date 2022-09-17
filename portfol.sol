pragma solidity ^0.8.11;

contract portfolio {
    uint256 private static_task_id;
    address manager;

    struct Task {
        uint256 id;
        string name;
        address from;
        address to;
        string content;
        string crypto;
        uint256 amount;
        string status;
    }

    Task[] public tasks;

    constructor() {
        static_task_id=0;
    }

    function create_tasks(string memory _name, address _from,
        address  _to,
        string memory _content,
        string memory _crypto,
        uint256 _amount,
        string memory status)  public payable {

        Task memory _inject = Task(++static_task_id,_name,_from,_to,_content,_crypto,_amount,"new");
        tasks.push(_inject);
        payable(_inject.from).transfer(_inject.amount);
    }

    function take_task(uint256 _task_id) public {
        for(uint256 i = 0; i <tasks.length; i++)
        {
            if(tasks[i].id == _task_id) {
                tasks[i].to=msg.sender;
                tasks[i].status="taken";
            }
        }

    }

    function pay_for_task(uint256 _task_id) public payable only_admin {
        for(uint256 i = 0; i <tasks.length; i++)
        {
            if(tasks[i].id==_task_id) {
                tasks[i].status="done";
                payable(tasks[i].to).transfer(tasks[i].amount);
            }
        }
    }

    modifier only_admin {
        require(msg.sender == manager," you are not an admin");
        _;
    }
}