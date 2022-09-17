// SPDX-License-Identifier: GPL-3.0
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
        uint256 _amount )  public payable {

        Task memory _inject = Task(++static_task_id,_name,_from,_to,_content,_crypto,_amount,"new");
        tasks.push(_inject);
    }

    function take_task(address worker, Task memory task) public payable {
    task.to=worker;
    task.status="taken";
    }

    function pay_for_task(Task memory task) public payable only_admin {
        task.status="done";
        payable(task.to).transfer(task.amount);
    }

    modifier only_admin {
        require(msg.sender == manager," you are not an admin");
        _;
    }


}
