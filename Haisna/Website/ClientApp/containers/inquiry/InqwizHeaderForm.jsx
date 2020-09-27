import React from 'react';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';

import Button from '../../components/control/Button';
import { FieldSet, FieldItem } from '../../components/Field';

import ListHeaderFormBase from '../../components/common/ListHeaderFormBase';

import { initializeInquiryPersonList, getInquiryPersonListRequest } from '../../modules/inquiry/inquiryModule';

const InqwizHeader = (props) => (
  <ListHeaderFormBase {...props} >
    <FieldSet>
      <FieldItem>検索条件</FieldItem>
      <Field name="keyword" component="input" type="text" />
      &nbsp;&nbsp;<Button type="submit" value="検索" />
    </FieldSet>
  </ListHeaderFormBase>
);

const InqwizHeaderForm = reduxForm({
  form: 'inqwizHeader',
  enableReinitialize: true,
})(InqwizHeader);

const mapStateToProps = (state) => ({
  initialValues: { keyword: state.app.inquiry.inquiry.inqPersonList.conditions.keyword },
});

const mapDispatchToProps = (dispatch) => ({
  initializeList: () => {
    dispatch(initializeInquiryPersonList());
  },
  onSearch: (conditions) => {
    let { keyword } = conditions;

    if (typeof (keyword) !== 'undefined') {
      keyword = keyword.trim();

      if (keyword !== '') {
        const [page, limit] = [1, 20];
        dispatch(getInquiryPersonListRequest({ page, limit, ...conditions }));
      }
    } else {
      dispatch(initializeInquiryPersonList());
    }
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(InqwizHeaderForm));
