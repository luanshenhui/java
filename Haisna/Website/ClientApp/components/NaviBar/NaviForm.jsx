import React from 'react';
import Search from '@material-ui/icons/Search';
import styled from 'styled-components';

const Form = styled.form`
  display: flex;
`;

const Input = styled.input.attrs({
  type: 'text',
})`
  border: 1px solid #b8b4ac;
  border-radius: 0;
  box-sizing: border-box;
  height: 25px;
  padding: 1px 2px;
  width: 210px;
`;

const SearchButton = styled.button.attrs({
  type: 'submit',
})`
  border: none;
  background-color: #b8b4ac;
  height: 25px;
  width: 25px;
`;

const SearchIcon = styled(Search)`
  color: #ffffff;
`;

const NaviForm = () => (
  <Form>
    <Input />
    <SearchButton>
      <SearchIcon />
    </SearchButton>
  </Form>
);

export default NaviForm;
